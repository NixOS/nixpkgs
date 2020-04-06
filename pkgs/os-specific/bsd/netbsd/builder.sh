source $stdenv/setup

# NetBSD makefiles should be able to detect this
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

  export INSTALL_FILE="install -U -c"
  export INSTALL_DIR="xinstall -U -d"
  export INSTALL_LINK="install -U -l h"
  export INSTALL_SYMLINK="install -U -l s"

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
  makeFlags="MANDIR=${!outputMan}/share/man $makeFlags"
  makeFlags="INFODIR=${!outputInfo}/share/info $makeFlags"
  makeFlags="DOCDIR=${!outputDoc}/share/doc $makeFlags"
  makeFlags="LOCALEDIR=${!outputLib}/share/locale $makeFlags"

  # Parallel building. Needs the space.
  makeFlags="-j $NIX_BUILD_CORES $makeFlags"
}

setNetBSDSourceDir() {
  # merge together all extra paths
  # there should be a better way to do this
  sourceRoot=$PWD/$sourceRoot
  export NETBSDSRCDIR=$sourceRoot
  export BSDSRCDIR=$NETBSDSRCDIR
  export _SRC_TOP_=$NETBSDSRCDIR
  chmod -R u+w $sourceRoot
  for path in $extraPaths; do
    cd $path
    find . -type d -exec mkdir -p $sourceRoot/\{} \;
    find . -type f -exec cp -pr \{} $sourceRoot/\{} \;
    chmod -R u+w $sourceRoot
  done

  cd $sourceRoot
  if [ -d "$NETBSD_PATH" ]
    then sourceRoot=$sourceRoot/$NETBSD_PATH
  fi
}

includesPhase() {
  if [ -z "${skipIncludesPhase:-}" ]; then

    local flagsArray=(
         $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
         DESTDIR=${!outputInclude} includes
    )

    echoCmd 'includes flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    moveUsrDir

  fi
}

moveUsrDir() {
  if [ -d $prefix ]; then
    # Remove lingering /usr references
    if [ -d $prefix/usr ]; then
      cd $prefix/usr
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec mv \{} $out/\{} \;
    fi

    find $prefix -type d -empty -delete
  fi
}

postUnpackHooks+=(setNetBSDSourceDir)
preConfigureHooks+=(addMakeFlags)
preInstallHooks+=(includesPhase)
fixupOutputHooks+=(moveUsrDir)

genericBuild
