{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  fuse,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "catfs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OvmtU2jpewP5EqPwEFAf67t8UCI1WuzUO2QQj4cH1Ak=";
  };

  patches = [
    # monitor https://github.com/kahing/catfs/issues/71
    ./fix-for-rust-1.65.diff
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fd-0.2.3" = "sha256-Xps5s30urCZ8FZYce41nOZGUAk7eRyvObUS/mMx6Tfg=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse ];

  # require fuse module to be active to run tests
  # instead, run command
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/catfs --help > /dev/null
  '';

  meta = with lib; {
    description = "Caching filesystem written in Rust";
    mainProgram = "catfs";
    homepage = "https://github.com/kahing/catfs";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
