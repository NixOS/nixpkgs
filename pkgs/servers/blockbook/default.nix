{ stdenv
, buildGoModule
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

buildGoModule rec {
  pname = "blockbook";
  version = "0.3.3";
  commit = "b6961ca";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    sha256 = "01nb4if2dix2h95xvqvafil325jjw2a4v1izb9mad0cjqcf8rk6n";
  };

  modSha256 = "1zp06mpkxaxykw8pr679fg9dd7039qj13j5lknxp7hr8dga0jvpy";

  buildInputs = [ bzip2 zlib snappy zeromq lz4 ];

  nativeBuildInputs = [ pkg-config packr ];

  buildFlagsArray = ''
    -ldflags=
       -X github.com/trezor/blockbook/common.version=${version}
       -X github.com/trezor/blockbook/common.gitcommit=${commit}
       -X github.com/trezor/blockbook/common.buildDate=unknown
  '';

  preBuild = lib.optionalString stdenv.isDarwin ''
    ulimit -n 8192
  '' + ''
    export CGO_CFLAGS="-I${rocksdb}/include"
    export CGO_LDFLAGS="-L${rocksdb}/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"
    packr clean && packr
  '';

  subPackages = [ "." ];

  meta = with lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mmahut maintainers."1000101" ];
    platforms = remove "aarch64-linux" platforms.unix;
  };
}
