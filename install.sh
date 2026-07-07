#!/bin/bash

# 1. Install modern bash (macOS ships bash 3.2 from 2007 due to GPLv3 licensing):

brew install bash

# 2. Add the new bash to allowed shells:

echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells

# 3. Set it as your default shell:

chsh -s /opt/homebrew/bin/bash

# 4. Symlink these dotfiles into place:

ln -sf ~/Desktop/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/Desktop/dotfiles/.bashrc ~/.bashrc

# 5. Open a new terminal session. Verify with:

echo $BASH_VERSION   # Should show 5.x

# 6. Move your API keys out of this file and into ~/.secrets:

chmod 600 ~/.secrets
