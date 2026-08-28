#!/usr/bin/env bash

# Default target user (change 'guest' if your account uses a different name)
TARGET_USER="${1:-guest}"
ACTION="${2:-toggle}"

CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/hide-users.conf"

# Ensure script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run with sudo."
   exit 1
fi

mkdir -p "$CONF_DIR"

is_hidden() {
    [[ -f "$CONF_FILE" ]] && grep -qE "^HideUsers=.*\b${TARGET_USER}\b" "$CONF_FILE"
}

hide_user() {
    if is_hidden; then
        echo "User '$TARGET_USER' is already hidden in SDDM."
        return
    fi

    if [[ ! -f "$CONF_FILE" ]]; then
        printf "[Users]\nHideUsers=%s\n" "$TARGET_USER" > "$CONF_FILE"
    elif grep -q "^HideUsers=" "$CONF_FILE"; then
        # Append user to existing HideUsers line
        sed -i "/^HideUsers=/s/$/,$TARGET_USER/" "$CONF_FILE"
        sed -i "s/=,=/=/; s/=,/$TARGET_USER/" "$CONF_FILE"
    else
        if grep -q "\[Users\]" "$CONF_FILE"; then
            sed -i "/\[Users\]/a HideUsers=$TARGET_USER" "$CONF_FILE"
        else
            printf "\n[Users]\nHideUsers=%s\n" "$TARGET_USER" >> "$CONF_FILE"
        fi
    fi
    echo "Done: User '$TARGET_USER' is now HIDDEN from SDDM."
}

unhide_user() {
    if ! is_hidden; then
        echo "User '$TARGET_USER' is already visible in SDDM."
        return
    fi

    # Remove target user and clean up extra commas
    sed -i -E "s/\b${TARGET_USER}\b//g" "$CONF_FILE"
    sed -i -E 's/,+/,/g; s/HideUsers=,/HideUsers=/g; s/,$//g' "$CONF_FILE"

    # Remove the config file if HideUsers line becomes empty
    if grep -qE "^HideUsers=\s*$" "$CONF_FILE"; then
        rm -f "$CONF_FILE"
        echo "Removed empty configuration file ($CONF_FILE)."
    fi

    echo "Done: User '$TARGET_USER' is now VISIBLE in SDDM."
}

case "$ACTION" in
    hide)
        hide_user
        ;;
    unhide)
        unhide_user
        ;;
    toggle)
        if is_hidden; then
            unhide_user
        else
            hide_user
        fi
        ;;
    *)
        echo "Usage: sudo $0 [username] [hide|unhide|toggle]"
        exit 1
        ;;
esac
