{ stdenv
, fetchurl
, skalibs
, skarnetConfCompile
}:

let

  version = "1.0.3.2";

in stdenv.mkDerivation rec {

  name = "s6-portable-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "040nmls7qbgw8yn502lym4kgqh5zxr2ks734bqajpi2ricnasvhl";
  };

  buildInputs = [ skalibs skarnetConfCompile ];

  sourceRoot = "admin/${name}";

  preInstall = ''
    mkdir -p "$out/libexec"
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
