# Prevent running as root.
if [ ${UID} == 0 ]; then
    echo -e "DO NOT RUN THIS SCRIPT AS 'root' !"
    echo -e "If 'root' privileges needed, you will prompted for sudo password."
    exit 1
fi

# Force script to exit if an error occurs
set -e

# Find SRCDIR from the pathname of this script
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/ && pwd )"

# Default Parameters
KLIPPER_CONFIG_DIR="${HOME}/klipper_config"
KLIPPY_EXTRAS="${HOME}/klipper/klippy/extras"
MACRO_DIR="${HOME}/klipper_config/bbs"

function stop_klipper {
    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "klipper.service")" ]; then
        sudo systemctl stop klipper
    else
        echo "Klipper service not found, please install Klipper first"
        exit 1
    fi
}

function start_klipper {
    sudo systemctl restart klipper
}

function create_config_dir {
    if [ -d "${MACRO_DIR}" ]; then
        rm -rf "${MACRO_DIR}"
    fi
    if [ -d "${KLIPPER_CONFIG_DIR}" ]; then
        mkdir "${MACRO_DIR}"
    else
        echo -e "ERROR: ${KLIPPER_CONFIG_DIR} not found."
        exit 1
    fi
}

function link_config {
    if [ -d "${KLIPPER_CONFIG_DIR}" ]; then
        if [ -d "${MACRO_DIR}" ]; then
            rm -f "${MACRO_DIR}/bbs.cfg"
            ln -sf "${SRCDIR}/config/bbs.cfg" "${MACRO_DIR}/bbs.cfg"
        else
            echo -e "ERROR: ${MACRO_DIR} not found."
            exit 1
        fi
    else
        echo -e "ERROR: ${KLIPPER_CONFIG_DIR} not found."
        exit 1
    fi
}

function link_extra {
    if [ -d "${KLIPPY_EXTRAS}" ]; then
        rm -f "${KLIPPY_EXTRAS}/belt_balance_system.py"
        ln -sf "${SRCDIR}/klippy_extra/belt_balance_system.py" "${KLIPPY_EXTRAS}/belt_balance_system.py"
    else
        echo -e "ERROR: ${KLIPPY_EXTRAS} not found."
        exit 1
    fi
}

### MAIN

# Parse command line arguments
while getopts "c:h" arg; do
    if [ -n "${arg}" ]; then
        case $arg in
            c)
                KLIPPER_CONFIG_DIR=$OPTARG
                break
            ;;
            [?]|h)
                echo -e "\nUsage: ${0} -c /path/to/klipper_config"
                exit 1
            ;;
        esac
    fi
    break
done

# Run steps

echo -e ""
echo -e ""
echo -e "Belt Balance System for RatOS"
echo -e "v0.1.0"
echo -e ""
stop_klipper
create_config_dir
link_config
link_extra
start_klipper
echo -e "Installation finished!"
echo -e ""
echo -e "Add this line to the overrides section in your printer.cfg"
echo -e "[include bbs/bbs.cfg]"
echo -e ""
echo -e ""
echo -e "Enjoy your balanced belts!"
echo -e ""

# If something checks status of install
exit 0