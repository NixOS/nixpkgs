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
  export DESTDIR=
  export USETOOLS=never
  export NOCLANGERROR=yes
  export NOGCCERROR=yes
  export LEX=flex
  export MKUNPRIVED=yes
  export EXTERNAL_TOOLCHAIN=yes

  makeFlags="MACHINE=$MACHINE $makeFlags"
  makeFlags="MACHINE_ARCH=$MACHINE_ARCH $makeFlags"
  makeFlags="AR=$AR $makeFlags"
  makeFlags="CC=$CC $makeFlags"
  makeFlags="CPP=$CPP $makeFlags"
  makeFlags="CXX=$CXX $makeFlags"
  makeFlags="LD=$LD $makeFlags"
  makeFlags="STRIP=$STRIP $makeFlags"

  makeFlags="BINDIR=${!outputBin}/bin $makeFlags"
  makeFlags="LIBDIR=${!outputLib}/lib $makeFlags"
  makeFlags="SHLIBDIR=${!outputLib}/lib $makeFlags"
  makeFlags="SHAREDIR=${!outputLib}/share $makeFlags"
  makeFlags="MANDIR=${!outputMan}/share/man $makeFlags"
  makeFlags="INFODIR=${!outputInfo}/share/info $makeFlags"
  makeFlags="DOCDIR=${!outputDoc}/share/doc $makeFlags"
  makeFlags="LOCALEDIR=${!outputLib}/share/locale $makeFlags"

  # Parallel building. Needs the space.
  makeFlags="-j $NIX_BUILD_CORES $makeFlags"
}

setBSDSourceDir() {
  sourceRoot=$PWD/$sourceRoot
  export BSDSRCDIR=$sourceRoot
  export _SRC_TOP_=$BSDSRCDIR
  cd $sourceRoot
}

cdBSDPath() {
  if [ -d "$COMPONENT_PATH" ]
    then sourceRoot=$sourceRoot/$COMPONENT_PATH
    cd $COMPONENT_PATH
  fi
}

includesPhase() {
  if [ -z "${skipIncludesPhase:-}" ]; then
    runHook preIncludes

    local flagsArray=(
         $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
         includes
    )

    echoCmd 'includes flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    moveUsrDir

    runHook postIncludes
  fi
}

moveUsrDir() {
  if [ -d $prefix ]; then
    # Remove lingering /usr references
    if [ -d $prefix/usr ]; then
      # Didn't try using rsync yet because per
      # https://unix.stackexchange.com/questions/127712/merging-folders-with-mv,
      # it's not neessarily better.
      pushd $prefix/usr
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec mv \{} $out/\{} \;
      popd
    fi

    find $prefix -type d -empty -delete
  fi
}

postUnpackHooks+=(setBSDSourceDir)
postPatchHooks+=(cdBSDPath)
preConfigureHooks+=(addMakeFlags)
preInstallHooks+=(includesPhase)
fixupOutputHooks+=(moveUsrDir)
