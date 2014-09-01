{ stdenv, fetchurl, skalibs }:

let

  version = "0.1.0.0";

in stdenv.mkDerivation rec {

  name = "s6-dns-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-dns/${name}.tar.gz";
    sha256 = "1r82l5fnz2rrwm5wq2sldqp74lk9fifr0d8hyq98xdyh24hish68";
  };

  buildInputs = [ skalibs ];

  sourceRoot = "web/${name}";

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
    homepage = http://www.skarnet.org/software/s6-dns/;
    description = "A suite of DNS client programs and libraries for Unix systems.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
