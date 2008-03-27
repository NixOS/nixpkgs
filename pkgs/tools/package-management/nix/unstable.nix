{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let version = "0.12pre11304"; in

stdenv.mkDerivation {
  name = "nix-${version}";
  
  src = fetchurl {
    url = "http://nixos.org/releases/nix/nix-${version}-6hxl2ybs/nix-${version}.tar.bz2";
    sha256 = "8f33687ed70d4e1453cf62c0a9c5010cc49ed787794320ef94e9ead740fd042b";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state
  '';

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nix.cs.uu.nl/;
    license = "LGPL";
  };
}
