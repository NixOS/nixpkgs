{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20560";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/322259/download/4/${name}.tar.bz2";
    sha256 = "16sjb8bdknzjqwhwlcxx1jwq3lij2lvz6vda3w1b6pjhhhclj58f";
  };

  buildNativeInputs = [perl];
  buildInputs = [curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
    --disable-init-state
  '';

  doCheck = true;

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}
