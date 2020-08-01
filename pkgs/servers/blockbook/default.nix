{ stdenv
, buildGoModule
, fetchFromGitHub
, packr
, pkg-config
, bzip2
, lz4
, rocksdb
, snappy
, zeromq
, zlib
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

  runVend = true;
  vendorSha256 = "0p7vyw61nwvmaz7gz2bdh9fi6wp62i2vnzw6iz2r8cims4sbz53b";

  nativeBuildInputs = [ packr pkg-config ];

  buildInputs = [ bzip2 lz4 rocksdb snappy zeromq zlib ];

  buildFlagsArray = ''
    -ldflags=
       -X github.com/trezor/blockbook/common.version=${version}
       -X github.com/trezor/blockbook/common.gitcommit=${commit}
       -X github.com/trezor/blockbook/common.buildDate=unknown
  '';

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    ulimit -n 8192
  '' + ''
    export CGO_LDFLAGS="-L${stdenv.cc.cc.lib}/lib -lrocksdb -lz -lbz2 -lsnappy -llz4 -lm -lstdc++"
    packr clean && packr
  '';

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/share/
    cp -r $src/static/templates/ $out/share/
    cp -r $src/static/css/ $out/share/
  '';

  meta = with stdenv.lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mmahut maintainers."1000101" ];
    platforms = platforms.unix;
  };
}
