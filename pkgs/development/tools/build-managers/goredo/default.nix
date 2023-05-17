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
  version = "1.30.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/${pname}-${version}.tar.zst";
    hash = "sha256-glsg2q8jFd4z6CuKzlZ3afJx/S7Aw6LCxFAS/uHLlUg=";
  };

  patches = [ ./fix-tests.diff ];

  nativeBuildInputs = [ zstd ];

  nativeCheckInputs = lib.optionals doCheck [ python3 perl ];

  inherit (sharness) SHARNESS_TEST_SRCDIR;

  vendorSha256 = null;

  modRoot = "./src";
  subPackages = [ "." ];

  postBuild = ''
    ( cd $GOPATH/bin; ./goredo -symlinks )
    cd ..
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export PATH=$GOPATH/bin:$PATH
    (cd t; prove -f .)
    runHook postCheck
  '';

  postInstall = ''
    mkdir -p "$out/share/info"
    cp goredo.info "$out/share/info"
  '';

  outputs = [ "out" "info" ];

  meta = with lib; {
    outputsToInstall = [ "out" ];
    description = "djb's redo, a system for building files from source files. Written in Go";
    homepage = "https://www.goredo.cypherpunks.ru";
    license = licenses.gpl3;
    maintainers = [ maintainers.spacefrogg ];
  };
}
