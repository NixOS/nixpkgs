# shellcheck shell=bash disable=SC2154,SC2164

# BSD makefiles should be able to detect this
# but without they end up using gcc on Darwin stdenv
addMakeFlags() {
  export setOutputFlags=

  export LIBCRT0=
  export LIBCRTI=
  export LIBCRTEND=
  export LIBCRTBEGIN=
  export LIBC=
  export LIBUTIL=
  export LIBSSL=
  export LIBCRYPTO=
  export LIBCRYPT=
  export LIBCURSES=
  export LIBTERMINFO=
  export LIBM=
  export LIBL=

  export _GCC_CRTBEGIN=
  export _GCC_CRTBEGINS=
  export _GCC_CRTEND=
  export _GCC_CRTENDS=
  export _GCC_LIBGCCDIR=
  export _GCC_CRTI=
  export _GCC_CRTN=
  export _GCC_CRTDIR=

  # Definitions passed to share/mk/*.mk. Should be pretty simple -
  # eventually maybe move it to a configure script.
  export USETOOLS=never
  export NOCLANGERROR=yes
  export NOGCCERROR=yes
  export LEX=flex
  export MKUNPRIVED=yes
  export EXTERNAL_TOOLCHAIN=yes

  prependToVar makeFlags "MACHINE=$MACHINE"
  prependToVar makeFlags "MACHINE_ARCH=$MACHINE_ARCH"
  prependToVar makeFlags "AR=$AR"
  prependToVar makeFlags "CC=$CC"
  prependToVar makeFlags "CPP=$CPP"
  prependToVar makeFlags "CXX=$CXX"
  prependToVar makeFlags "LD=$LD"
  prependToVar makeFlags "STRIP=$STRIP"

  prependToVar makeFlags "BINDIR=${!outputBin}/bin"
  prependToVar makeFlags "LIBDIR=${!outputLib}/lib"
  prependToVar makeFlags "SHLIBDIR=${!outputLib}/lib"
  prependToVar makeFlags "SHAREDIR=${!outputLib}/share"
  prependToVar makeFlags "INFODIR=${!outputInfo}/share/info"
  prependToVar makeFlags "DOCDIR=${!outputDoc}/share/doc"
  prependToVar makeFlags "LOCALEDIR=${!outputLib}/share/locale"

  # Parallel building. Needs the space.
  prependToVar makeFlags "-j $NIX_BUILD_CORES"
}

setBSDSourceDir() {
  sourceRoot=$PWD/$sourceRoot
  export BSDSRCDIR=$sourceRoot
  export _SRC_TOP_=$BSDSRCDIR
  cd "$sourceRoot"
}

cdBSDPath() {
  if [ -d "$COMPONENT_PATH" ]
    then sourceRoot=$sourceRoot/$COMPONENT_PATH
    cd "$COMPONENT_PATH"
  fi
}

includesPhase() {
  if [ -z "${skipIncludesPhase:-}" ]; then
    runHook preIncludes

    local flagsArray=()
    concatTo flagsArray makeFlags makeFlagsArray
    flagsArray+=(includes)

    echoCmd 'includes flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    moveUsrDir

    runHook postIncludes
  fi
}

moveUsrDir() {
  if [ -d "$prefix" ]; then
    # Remove lingering /usr references
    if [ -d "$prefix/usr" ]; then
      # Didn't try using rsync yet because per
      # https://unix.stackexchange.com/questions/127712/merging-folders-with-mv,
      # it's not necessarily better.
      pushd "$prefix/usr"
      find . -type d -exec mkdir -p "$out/{}" \;
      find . \( -type f -o -type l \) -exec mv "{}" "$out/{}" \;
      popd
    fi

    find "$prefix" -type d -empty -delete
  fi
}

postUnpackHooks+=(setBSDSourceDir)
postPatchHooks+=(cdBSDPath)
preConfigureHooks+=(addMakeFlags)
preInstallHooks+=(includesPhase)
fixupOutputHooks+=(moveUsrDir)
