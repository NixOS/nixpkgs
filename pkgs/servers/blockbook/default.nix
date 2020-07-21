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
  version = "0.3.4";
  commit = "eb4e10a";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    sha256 = "0da1kav5x2xcmwvdgfk1q70l1k0sqqj3njgx2xx885d40m6qbnrs";
  };

  vendorSha256 = "1qjlvhizl8cy06cgf4phia70bgbm4lj57z5z2gyr8aglx98bnpdn";

  buildInputs = [ bzip2 zlib snappy zeromq lz4 ];

  nativeBuildInputs = [ pkg-config packr ];

  buildFlagsArray = ''
    -ldflags=
       -X github.com/trezor/blockbook/common.version=${version}
       -X github.com/trezor/blockbook/common.gitcommit=${commit}
       -X github.com/trezor/blockbook/common.buildDate=unknown
  '';

  goethereum = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v1.8.20";
    sha256 = "0m2q1nz6f39pyr2rk6vflkwi4ykganzwr7wndpwr9rliw0x8jgi0";
  };

  overrideModAttrs = (_: {
      postBuild = ''
      rm -r vendor/github.com/ethereum/go-ethereum
      cp -r --reflink=auto ${goethereum} vendor/github.com/ethereum/go-ethereum
      '';
    });

  preBuild = lib.optionalString stdenv.isDarwin ''
    ulimit -n 8192
  '' + ''
    export CGO_CFLAGS="-I${rocksdb}/include"
    export CGO_LDFLAGS="-L${rocksdb}/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"
    packr clean && packr
  '';

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/share/
    cp -r $src/static/templates/ $out/share/
    cp -r $src/static/css/ $out/share/
  '';

  meta = with lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mmahut maintainers."1000101" ];
    platforms = remove "aarch64-linux" platforms.unix;
  };
}
