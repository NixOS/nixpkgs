{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, installShellFiles
, darwin
, pandoc
, testers
, lsd
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${version}";
    hash = "sha256-ZMaI0Q/xmYJHWvU4Tha+XVV55zKLukrqkROfBzu/JsQ=";
  };

  cargoPatches = [
    # fix cargo lock file
    (fetchpatch {
      url = "https://github.com/lsd-rs/lsd/pull/1021/commits/7593fd7ea0985e273c82b6e80e66a801772024de.patch";
      hash = "sha256-ykKLVSM6FbL4Jt5Zk7LuPKcYw/wrpiwU8vhuGz8Pbi0=";
    })
  ];

  cargoHash = "sha256-TDHHY5F4lVrKd7r0QfrfUV2xzT6HMA/PtOIStMryaBA=";

  nativeBuildInputs = [ installShellFiles pandoc ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    pandoc --standalone --to man doc/lsd.md -o lsd.1
    installManPage lsd.1

    installShellCompletion --cmd lsd \
      --bash $releaseDir/build/lsd-*/out/lsd.bash \
      --fish $releaseDir/build/lsd-*/out/lsd.fish \
      --zsh $releaseDir/build/lsd-*/out/_lsd
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = lsd;
  };

  meta = with lib; {
    homepage = "https://github.com/lsd-rs/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ zowoq SuperSandro2000 ];
    mainProgram = "lsd";
  };
}
