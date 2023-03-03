* Format MacOs to have latest OS
* Setup Apple ID (Settings / Internet Account / iCloud)

* Install Xcode:
  ```bash
  xcode-select --install
  ```

* Install Homebrew and cask:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  brew install cask
  ```

* Install git:
  ```bash
  brew install git
  ```

* Clone repo into new hidden directory:
  ```bash
  git clone https://github.com/letiesperon/macsetup.git ~/.macsetup
  ```

* Create symlinks in the Home directory to the real files in the repo:
  ```bash
  ln -s ~/.macsetup/* ~/
  ```

* Install the software listed in the Brewfile:
  ```bash
  brew bundle --file ~/.macsetup/dotfiles/Brewfile
  ```

* Manually sign in to 1Password
* Manually sign in to Google Chrome to sync bookmarks
* Manually sign in to Workona
* Manually sign in to all my gmail.com accounts in Google Chrome
* Manually add Internet Account of all my email accounts
* Manually sign in in VSCode with Github to sync settings

* Install ohMyZsh
  ```bash
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sh install.sh
  ```

* Install [zsh extension](https://formulae.brew.sh/formula/zsh-syntax-highlighting):
  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

* Restart terminal

* Setup sublime text to be editor by default and configure `subl .` shortcut to open files:
  ```bash
  // Test first: this should open subl:
  /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl .

  export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
  export EDITOR='subl -w'
  ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  ```

* [Setup local git to your github account](https://gist.github.com/letiesperon/ce8217bc99195032f9dda3c67b424150)
* [Setup Sublime preferences](https://gist.github.com/letiesperon/7090a100902871cb2b9f6941a1f430ed)

