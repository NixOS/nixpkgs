{ buildGoModule
, fetchurl
, lib
, zstd
, sharness
, python3
, perl
}:

buildGoModule rec {
  pname = "goredo";
  version = "1.21.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/${pname}-${version}.tar.zst";
    hash = "sha256-h882pt+xZWlhFLQar1kfmSAzMscwMXAajT6ezZl9P8M=";
  };

  patches = [ ./fix-tests.diff ];

  nativeBuildInputs = [ zstd ];

  nativeCheckInputs = lib.optionals doCheck [ python3 perl ];

  SHARNESS_TEST_SRCDIR = sharness + "/share/sharness";

  vendorSha256 = null;
  subPackages = [ "." ];

  preBuild = "cd src";

  postBuild = ''
    ( cd $GOPATH/bin; ./goredo -symlinks )
    cd ..
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export PATH=$GOPATH/bin:$PATH
    prove -f
    runHook postCheck
  '';

  postInstall = ''
    mkdir -p "$out/share/info"
    cp goredo.info "$out/share/info"
  '';

  outputs = [ "out" "info" ];

  meta = with lib; {
    description = "djb's redo, a system for building files from source files. Written in Go";
    homepage = "https://www.goredo.cypherpunks.ru";
    license = licenses.gpl3;
    maintainers = [ maintainers.spacefrogg ];
  };
}
