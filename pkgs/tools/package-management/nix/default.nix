{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/326788/download/4/${name}.tar.bz2";
    sha256 = "2d125e75dba387075a8bd443926d7fc6752e54cc9a21c2ef32e44fffc445a8ce";
  };

  buildInputs = [ perl curl openssl ];

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-aterm=${aterm} --with-bzip2=${bzip2}
      ${stdenv.lib.optionalString (openssl != null) "--with-openssl=${openssl}"}
      --disable-init-state
    '';

  doCheck = true;

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
