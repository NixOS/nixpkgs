{ stdenv, fetchurl, skalibs }:

let

  version = "1.0.3.2";

in stdenv.mkDerivation rec {

  name = "s6-portable-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "040nmls7qbgw8yn502lym4kgqh5zxr2ks734bqajpi2ricnasvhl";
  };

  buildInputs = [ skalibs ];

  sourceRoot = "admin/${name}";

  configurePhase = ''
    pushd conf-compile

    printf "$out/bin"           > conf-install-command
    printf "$out/libexec"       > conf-install-libexec

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

  preInstall = ''
    mkdir -p "$out/libexec"
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size.";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
