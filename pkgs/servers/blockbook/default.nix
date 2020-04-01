{ stdenv
, buildGoPackage
, lib
, fetchFromGitHub
, rocksdb
, bzip2
, zlib
, packr
, snappy
, pkg-config
, zeromq
, lz4
}:

buildGoPackage rec {
  pname = "blockbook";
  version = "0.3.2";

  goPackagePath = "blockbook";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    sha256 = "0hcgz4b7k8ia4dnjg6bbii95sqg3clc40ybwwc4qz3jv21ikc54x";
  };

  goDeps = ./deps.nix;

  buildInputs = [ bzip2 zlib snappy zeromq lz4 ];

  nativeBuildInputs = [ pkg-config packr ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    ulimit -n 8192
  '' + ''
    export CGO_CFLAGS="-I${rocksdb}/include"
    export CGO_LDFLAGS="-L${rocksdb}/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"
    packr clean && packr
  '';

  postInstall = ''
    rm $bin/bin/{scripts,templates,trezor-common}
  '';

  meta = with lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.all;
  };
}

