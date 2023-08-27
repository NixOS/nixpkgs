# set variables for non-wrapped binaries
if [[ -z "${TEXMFCNF+set}" ]] ; then
  export TEXMFCNF='@texmfCnf@'
fi
if [[ -z "${FONTCONFIG_FILE+set}" ]] ; then
  export FONTCONFIG_FILE='@fontconfigFile@'
fi
