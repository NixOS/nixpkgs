{ stdenv, fetchurl, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre21802";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/410078/download/4/${name}.tar.bz2";
    sha256 = "dec142f401fd0aab771eebcddf8354edc57d9a05f63f07f0e74dd7c499df8cf8";
  };

  buildInputs = [ perl curl openssl ];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-bzip2=${bzip2} --with-sqlite=${sqlite}
    --disable-init-state
    CFLAGS=-O3 CXXFLAGS=-O3
  '';

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
