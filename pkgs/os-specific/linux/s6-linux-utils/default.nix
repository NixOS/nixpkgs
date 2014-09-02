{ stdenv, fetchurl, skalibs }:

let

  version = "1.0.3.1";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "1s17g03z5hfpiz32g001g5wyamyvn9l36fr2csk3k7r0jkqfnl0d";
  };

  buildInputs = [ skalibs ];

  sourceRoot = "admin/${name}";

  configurePhase = ''
    pushd conf-compile

    printf "$out/bin"           > conf-install-command
    printf "$out/include"       > conf-install-include
    printf "$out/lib"           > conf-install-library
    printf "$out/lib"           > conf-install-library.so

    # let nix builder strip things, cross-platform
    truncate --size 0 conf-stripbins
    truncate --size 0 conf-striplibs

    printf "${skalibs}/sysdeps"      > import
    printf "%s" "${skalibs}/include" > path-include
    printf "%s" "${skalibs}/lib"     > path-library

    rm -f flag-slashpackage
    touch flag-allstatic

    popd
  '';

  preBuild = ''
    patchShebangs src/sys
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-linux-utils/;
    description = "A set of minimalistic Linux-specific system utilities.";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
  };

}
