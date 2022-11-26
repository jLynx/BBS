# BBS for RatOS
Belt Balance System RatOS

# 1. Install
SSH into your Raspberry PI and execute:
```
cd ~/
git clone https://github.com/jLynx/BBS.git
bash ~/bbs/install.sh
```

# 2. Activate
Add this to the overwrite section at the end of your printer.cfg file.
```ini
# BBS
[include bbs/bbs.cfg]
```
# 3. Update
If you want to receive updates for BBS put this at the end of the moonraker.conf file.
```ini
# BBS
[update_manager bbs]
type: git_repo
primary_branch: main
path: ~/bba
origin: https://github.com/jLynx/BBS.git
is_system_service: False
```