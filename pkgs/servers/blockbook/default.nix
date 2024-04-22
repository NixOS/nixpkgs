{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, bzip2
, lz4
, rocksdb_7_10
, snappy
, zeromq
, zlib
, nixosTests
}:

let
  rocksdb = rocksdb_7_10;
in
buildGoModule rec {
  pname = "blockbook";
  version = "0.4.0";
  commit = "5f8cf45";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    hash = "sha256-98tp3QYaHfhVIiJ4xkA3bUanXwK1q05t+YNroFtBUxE=";
  };

  vendorHash = "sha256-KJ92WztrtKjibvGBYRdnRag4XeZS4d7kyskJqD4GLPE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ bzip2 lz4 rocksdb snappy zeromq zlib ];

  ldflags = [
    "-X github.com/trezor/blockbook/common.version=${version}"
    "-X github.com/trezor/blockbook/common.gitcommit=${commit}"
    "-X github.com/trezor/blockbook/common.buildDate=unknown"
  ];

  tags = [ "rocksdb_7_10" ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    ulimit -n 8192
  '' + ''
    export CGO_LDFLAGS="-L${stdenv.cc.cc.lib}/lib -lrocksdb -lz -lbz2 -lsnappy -llz4 -lm -lstdc++"
    buildFlagsArray+=("-tags=${lib.concatStringsSep " " tags}")
    buildFlagsArray+=("-ldflags=${lib.concatStringsSep " " ldflags}")
  '';

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/share/
    cp -r $src/static/templates/ $out/share/
    cp -r $src/static/css/ $out/share/
  '';

  passthru.tests = {
    smoke-test = nixosTests.blockbook-frontend;
  };

  meta = with lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mmahut _1000101 ];
    platforms = platforms.unix;
    mainProgram = "blockbook";
  };
}
