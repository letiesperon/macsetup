---
name: investigate-ci-failure
description: Use when the user asks to investigate a CI failure, debug a failed build, look at failing checks on a PR, find out why CI failed, check why tests failed on a PR, or fetch Azure DevOps build logs. Pulls failing-job logs from RevenueCat's Azure DevOps pipelines given a PR URL or PR number.
---

# Investigate CI Failure (RevenueCat / Azure DevOps)

RevenueCat uses Azure DevOps for CI. Defaults: org `https://dev.azure.com/RevenueCat`, project `cad2c921-847e-4fcc-b387-35f2d4073246`.

## Steps

Given a PR URL or PR number + repo name:

### 1. Get the failing checks from GitHub

```
gh pr view <pr_number> --repo RevenueCat/<repo> --json statusCheckRollup \
  --jq '.statusCheckRollup[] | select(.conclusion=="FAILURE") | {name, detailsUrl}'
```

### 2. Extract the Azure DevOps `buildId`

Pull `buildId=<NUMBER>` out of the `detailsUrl` (e.g. `buildId=185018`).

### 3. Find the failed jobs/tasks in that build

```
az devops invoke \
  --area build --resource timeline \
  --route-parameters project=cad2c921-847e-4fcc-b387-35f2d4073246 buildId=<BUILD_ID> \
  --org https://dev.azure.com/RevenueCat \
  --query "records[?result=='failed'].{name:name, id:id, log:log}" \
  -o json
```

The `log` field in each record contains a `logId`.

### 4. Fetch the log content for each failed task

```
az devops invoke \
  --area build --resource logs \
  --route-parameters project=cad2c921-847e-4fcc-b387-35f2d4073246 buildId=<BUILD_ID> logId=<LOG_ID> \
  --org https://dev.azure.com/RevenueCat -o json \
  | python3 -c "import sys,json; data=json.load(sys.stdin); [print(l) for l in data.get('value',[])]"
```

### 5. Filter for errors

Pipe step 4 through:

```
grep -i -A 5 "fail\|error\|FAIL"
```

## Auth troubleshooting

If any `az devops` call fails with auth errors, tell the user to re-authenticate:

```
az devops login --org https://dev.azure.com/RevenueCat
```

A PAT with **Build (Read)** scope is required, from https://dev.azure.com/RevenueCat/_usersSettings/tokens.
