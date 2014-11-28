# Packages from skarnet.org use a unique build system. These functions
# assist with some common configuration and shebang patching.

skarnetConfigure() {
  runHook preConfigure

  pushd conf-compile >/dev/null

  # paths
  > conf-defaultpath         printf "$out/bin"
  > conf-etc                 printf "$out/etc"
  > conf-install-command     printf "$out/bin"
  > conf-install-include     printf "$out/include"
  > conf-install-libexec     printf "$out/libexec"
  > conf-install-library     printf "$out/lib"
  > conf-install-library.so  printf "$out/lib"
  > conf-install-sysdeps     printf "$out/sysdeps"

  # let nix builder strip things, cross-platform
  truncate --size 0 conf-stripbins conf-striplibs

  rm -f flag-slashpackage
  touch flag-allstatic
  touch flag-forcedevr          # only used for skalibs

  # build inputs
  truncate --size 0 import path-include path-library
  for input in $nativeBuildInputs; do
    [[ -a "$input/sysdeps" ]] && >> import       printf "$input/sysdeps"
    [[ -a "$input/include" ]] && >> path-include printf "$input/include"
    [[ -a "$input/lib" ]]     && >> path-library printf "$input/lib"
  done

  popd >/dev/null

  # patch various scripts to use stdenv shell
  patchShebangs src/sys

  runHook postConfigure
}

export configurePhase=skarnetConfigure
