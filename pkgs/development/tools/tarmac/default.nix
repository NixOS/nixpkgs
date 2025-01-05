{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "tarmac";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "tarmac";
    rev = "v${version}";
    sha256 = "sha256-O6qrAzGiAxiE56kpuvH/jDKHRXxHZ2SlDL5nwOOd4EU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
    ];

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Resource compiler and asset manager for Roblox";
    mainProgram = "tarmac";
    longDescription = ''
      Tarmac is a resource compiler and asset manager for Roblox projects.
      It helps enable hermetic place builds when used with tools like Rojo.
    '';
    homepage = "https://github.com/Roblox/tarmac";
    downloadPage = "https://github.com/Roblox/tarmac/releases/tag/v${version}";
    changelog = "https://github.com/Roblox/tarmac/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wackbyte ];
  };
}
