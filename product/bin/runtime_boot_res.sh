#!/bin/sh

LOG_TAG="runtime_boot_res"
# TODO: Rename runtime_boot_res to check_google_submission in Q-OS
log -p i -t "${LOG_TAG}" "[SBP] Check Google submission"

CUPSS_ROOT_DIR=$(getprop ro.vendor.lge.capp_cupss.rootdir /product/OP)
OP_ROOT_PATH=$(/product/bin/laop_cmd getprop ro.vendor.lge.capp_cupss.op.dir)
USER_APP_MANAGER_INSTALLATION_FILE=/data/local/app-ntcode-conf.json
DOWNCA_APP_MANAGER_INSTALLATION_FILE=$CUPSS_ROOT_DIR/config/app-special-conf.json

if [ -d $OP_ROOT_PATH ]; then
    if [ ! -f $DOWNCA_APP_MANAGER_INSTALLATION_FILE ]; then
        DOWNCA_APP_MANAGER_INSTALLATION_FILE=$OP_ROOT_PATH/_COMMON/app-enabled-conf.json
    fi
fi
rm ${USER_APP_MANAGER_INSTALLATION_FILE}

# Single CA Google submission
SINGLECA_SUBMIT=$(/product/bin/laop_cmd getprop ro.vendor.lge.singleca.submit)
if [ "${SINGLECA_SUBMIT}" = "1" ]; then
    if [ -f "${DOWNCA_APP_MANAGER_INSTALLATION_FILE}" ]; then
        ln -sf ${DOWNCA_APP_MANAGER_INSTALLATION_FILE} ${USER_APP_MANAGER_INSTALLATION_FILE}
        log -p i -t "${LOG_TAG}" "[SBP] Single CA Google submission"
    fi
fi

exit 0
