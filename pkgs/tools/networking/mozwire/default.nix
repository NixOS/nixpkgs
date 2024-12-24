{
  rustPlatform,
  lib,
  stdenv,
  fetchFromGitHub,
  CoreServices,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "MozWire";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2i8C1XgfI3MXnwXZzY6n8tIcw45G9h3vZqRlFaVoLH0=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
    Security
  ];

  cargoHash = "sha256-YXVH7kx5CiurTeXiphjDgcYxxovKtTF3Q9y/XOyVPUA=";

  meta = with lib; {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      siraben
      nilsirl
    ];
    mainProgram = "mozwire";
  };
}
