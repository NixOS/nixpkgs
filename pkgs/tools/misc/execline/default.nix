{stdenv, fetchurl, skalibs}:

let

  version = "1.3.1.1";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchurl {
    url = "http://skarnet.org/software/execline/${name}.tar.gz";
    sha256 = "1br3qzif166kbp4k813ljbyq058p7mfsp2lj88n8vi4dmj935nzg";
  };

  buildInputs = [ skalibs ];

  sourceRoot = "admin/${name}";

  configurePhase = ''
    pushd conf-compile

    printf "$out/bin"     > conf-install-command
    printf "$out/include" > conf-install-include
    printf "$out/lib"     > conf-install-library
    printf "$out/lib"     > conf-install-library.so
    printf "$out/sysdeps" > conf-install-sysdeps

    printf "${skalibs}/sysdeps" > import
    printf "${skalibs}/include" > path-include
    printf "${skalibs}/lib"     > path-library

    # let nix builder strip things, cross-platform
    truncate --size 0 conf-stripbins
    truncate --size 0 conf-striplibs

    rm -f flag-slashpackage
    touch flag-allstatic

    popd
  '';

  preBuild = ''
    patchShebangs src/sys
  '';

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
