{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
, pandoc
, testers
, lsd
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${version}";
    hash = "sha256-pPCcKEmB1/BS6Q2j1fytwpZa/5KXIJu0ip0Zq97m6uw=";
  };

  cargoHash = "sha256-E0ui9cmuSqUMTkKvNNuEPOVd/gs4O2oW0aPxlyI9qoA=";

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
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 ];
    mainProgram = "lsd";
  };
}
