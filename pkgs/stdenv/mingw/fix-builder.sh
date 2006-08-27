# Workaround MSYS shell problem

if test -z "$out"; then
  buildInputs=$BUILDINPUTS
  buildUtilities=$BUILDUTILITIES
  configureFlags=$CONFIGUREFLAGS
  doCheck=$DOCHECK
  doCoverageAnalysis=$DOCOVERAGEANALYSIS
  dontInstall=$DONTINSTALL
  dontLogThroughTee=$DONTLOGTHROUGHTEE
  lcov=$LCOV
  logPhases=$LOGPHASES
  out=$OUT
  patches=$PATCHES
  propagatedBuildInputs=$PROPAGATEDBUILDINPUTS
  stdenv=$STDENV
  src=$SRC
  srcs=$SRCS
  succeedOnFailure=$SUCCEEDONFAILURE
  system=$SYSTEM
fi

source $@
