# Workaround MSYS shell problem

if test -z "$out"; then
  stdenv=$STDENV
  out=$OUT
  src=$SRC
  srcs=$SRCS
  buildInputs=$BUILDINPUTS
  propagatedBuildInputs=$PROPAGATEDBUILDINPUTS
  succeedOnFailure=$SUCCEEDONFAILURE
  patches=$PATCHES
  doCheck=$DOCHECK
  configureFlags=$CONFIGUREFLAGS
fi

source $@
