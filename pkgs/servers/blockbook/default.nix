{ buildGoPackage
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
  version = "0.3.1";

  goPackagePath = "blockbook";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    sha256 = "0qgd1f3b4vavw55mvpvwvlya39dx1c3kjsc7n46nn7kpc152jv1l";
  };

  goDeps = ./deps.nix;

  buildInputs = [ bzip2 zlib snappy zeromq lz4 ];

  nativeBuildInputs = [ pkg-config packr ];

  preBuild = ''
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

