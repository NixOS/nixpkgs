# set variables for non-wrapped binaries
if [[ -z "${TEXMFCNF+set}" ]] ; then
  export TEXMFCNF='@texmfCnf@'
fi
if [[ -z "${FONTCONFIG_FILE+set}" ]] ; then
  export FONTCONFIG_FILE='@fontconfigFile@'
fi

# add trailing colon, unless there is already an empty entry
# (see Kpathsea manual 5.3.1 Default expansion)
if [[ -z "${TEXMFAUXTREES+set}" || ":${TEXMFAUXTREES-}:" != *::* ]] ; then
  export TEXMFAUXTREES="${TEXMFAUXTREES-}:"
fi
