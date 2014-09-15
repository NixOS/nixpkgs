{ stdenv
, execline
, fetchurl
, s6Dns
, skalibs
}:

let

  version = "0.1.0.0";

in stdenv.mkDerivation rec {

  name = "s6-networking-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-networking/${name}.tar.gz";
    sha256 = "1np9m2j1i2450mbcjvpbb56kv3wc2fbyvmv2a039q61j2lk6vjz7";
  };

  buildInputs = [ skalibs s6Dns execline ];

  sourceRoot = "net/${name}";

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

    rm -f path-include
    rm -f path-library
    for dep in "${execline}" "${s6Dns}" "${skalibs}"; do
      printf "%s\n" "$dep/include" >> path-include
      printf "%s\n" "$dep/lib"     >> path-library
    done

    rm -f flag-slashpackage
    touch flag-allstatic

    popd
  '';

  preBuild = ''
    patchShebangs src/sys
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-networking/;
    description = "A suite of small networking utilities for Unix systems.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
