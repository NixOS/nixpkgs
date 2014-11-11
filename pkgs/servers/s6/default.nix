{stdenv, fetchurl, skalibs, execline}:

let

  version = "1.1.3.2";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6/${name}.tar.gz";
    sha256 = "0djxdd3d3mlp63sjqqs0ilf8p68m86c1s98d82fl0kgaaibpsikp";
  };

  buildInputs = [ skalibs execline ];

  sourceRoot = "admin/${name}";

  configurePhase = ''
    pushd conf-compile

    printf "$out/bin"           > conf-install-command
    printf "$out/include"       > conf-install-include
    printf "$out/lib"           > conf-install-library
    printf "$out/lib"           > conf-install-library.so
    printf "$out/sysdeps"       > conf-install-sysdeps

    # let nix builder strip things, cross-platform
    truncate --size 0 conf-stripbins
    truncate --size 0 conf-striplibs

    printf "${skalibs}/sysdeps" > import
    printf "%s\n%s" "${skalibs}/include" "${execline}/include" > path-include
    printf "%s\n%s" "${skalibs}/lib"     "${execline}/lib"     > path-library

    rm -f flag-slashpackage
    touch flag-allstatic

    popd
  '';

  preBuild = ''
    substituteInPlace "src/daemontools-extras/s6-log.c" \
      --replace '"execlineb"' '"${execline}/bin/execlineb"'

    patchShebangs src/sys
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6/;
    description = "skarnet.org's small & secure supervision software suite";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
