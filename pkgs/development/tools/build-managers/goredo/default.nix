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
<<<<<<< HEAD
  version = "1.30.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/${pname}-${version}.tar.zst";
    hash = "sha256-glsg2q8jFd4z6CuKzlZ3afJx/S7Aw6LCxFAS/uHLlUg=";
=======
  version = "1.21.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/${pname}-${version}.tar.zst";
    hash = "sha256-h882pt+xZWlhFLQar1kfmSAzMscwMXAajT6ezZl9P8M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [ ./fix-tests.diff ];

  nativeBuildInputs = [ zstd ];

  nativeCheckInputs = lib.optionals doCheck [ python3 perl ];

<<<<<<< HEAD
  inherit (sharness) SHARNESS_TEST_SRCDIR;

  vendorSha256 = null;

  modRoot = "./src";
  subPackages = [ "." ];

=======
  SHARNESS_TEST_SRCDIR = sharness + "/share/sharness";

  vendorSha256 = null;
  subPackages = [ "." ];

  preBuild = "cd src";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postBuild = ''
    ( cd $GOPATH/bin; ./goredo -symlinks )
    cd ..
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export PATH=$GOPATH/bin:$PATH
<<<<<<< HEAD
    (cd t; prove -f .)
=======
    prove -f
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postCheck
  '';

  postInstall = ''
    mkdir -p "$out/share/info"
    cp goredo.info "$out/share/info"
  '';

  outputs = [ "out" "info" ];

  meta = with lib; {
<<<<<<< HEAD
    outputsToInstall = [ "out" ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "djb's redo, a system for building files from source files. Written in Go";
    homepage = "https://www.goredo.cypherpunks.ru";
    license = licenses.gpl3;
    maintainers = [ maintainers.spacefrogg ];
  };
}
