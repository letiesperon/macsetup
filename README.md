- Format MacOs to have latest OS
- Setup Apple ID (Settings / Internet Account / iCloud)

- Install Xcode:

  ```bash
  xcode-select --install
  ```

- Install Homebrew and cask:

  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  brew install cask
  ```

- Install git:

  ```bash
  brew install git
  ```

- Clone repo into new hidden directory:

  ```bash
  git clone https://github.com/letiesperon/macsetup.git ~/.macsetup
  ```

- Create symlinks in the Home directory to the real files in the repo:

  ```bash
  rm ~/.gitconfig
  ln -s ~/.macsetup/dotfiles/.gitconfig ~/.gitconfig
  ln -s ~/.macsetup/dotfiles/.gitignore ~/.gitignore
  ln -s ~/.macsetup/dotfiles/.zshrc ~/.zshrc
  ```

- Install the software listed in the Brewfile:

  ```bash
  brew bundle --file ~/.macsetup/dotfiles/Brewfile
  ```

- Manually sign in to 1Password
- Manually sign in to Google Chrome to sync bookmarks
- Manually sign in to Workona
- Manually sign in to all my gmail.com accounts in Google Chrome
- Manually add Internet Account of all my email accounts
- Manually sign in in VSCode with Github to sync settings
- Manually sign in to Warp with Google

- Install ohMyZsh

  ```bash
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sh install.sh
  ```

- Install [zsh extension](https://formulae.brew.sh/formula/zsh-syntax-highlighting):

  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

- Restart terminal

- Setup sublime text to be editor by default and configure `subl .` shortcut to open files:

  ```bash
  // Test first: this should open subl:
  /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .

  export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
  export EDITOR='subl -w'
  ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  ```

- Follow installation for rbenv [here](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment). In short, for ruby 2.\*:

  ```bash
  brew install openssl@1.1 readline libyaml gmp
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  ```

- Follow instructiond for postgres app installation [here](sudo mkdir -p /etc/paths.d &&
  echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp). In short:

  ```bash
  sudo mkdir -p /etc/paths.d &&
  echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
  ```

  (In some situation I had to reinstall xcode)

- Allow gem install bundler to succeed:

  ```bash
  export GEM_HOME="$HOME/.gem"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  ```

- Install node:

  ```bash
   sudo mkdir -p "/usr/local/n"
   sudo chown letiesperon "/usr/local/n"
   n lts
  ```

- [Setup local git to your github account](https://gist.github.com/letiesperon/ce8217bc99195032f9dda3c67b424150)
- [Setup Sublime preferences](https://gist.github.com/letiesperon/7090a100902871cb2b9f6941a1f430ed)

---

### Ruby projects considerations

I had to run

```ruby
brew link postgresql@15 --force
```

so that `pg` gem can be installed correctly.

When failing because role `postgres` is missing:

```
createuser -s postgres
brew services restart postgresql@15
```
