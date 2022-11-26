# BBS for RatOS
Belt Balance System RatOS.

Based off of [@JupaCreations](https://github.com/JupaCreations) awesome [Belt Balance System](https://github.com/JupaCreations/Belt-Balance-System).

ToDo:
- Fix the Python script so its not utter dogshit.
- Upload build guide.
- Upload PCB files.
- Upload photos.
- Upload BOM.
- Work out if the ESP8266/32 is needed for the current API, or if it can be done on a ATmega328P based micro via serial.

# 1. Install
SSH into your Raspberry PI and execute:
```
cd ~/
git clone https://github.com/jLynx/BBS.git
bash ~/BBS/install.sh
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
[update_manager BBS]
type: git_repo
primary_branch: main
path: ~/BBS
origin: https://github.com/jLynx/BBS.git
is_system_service: False
```