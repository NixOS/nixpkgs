export NIX_ENFORCE_PURITY=

if test -z "$cygwinConfigureEnableShared"; then
  export configureFlags="$configureFlags --disable-shared"
fi

PATH_DELIMITER=';'
