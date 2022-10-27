{ rustPlatform
, lib
, stdenv
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "MozWire";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vC8HmwJCHMKQUsYBwRmr88tmZxPKNvI6hxlcjG2AV3Q=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-9qXoMugmL6B9vC/yrMJxZ5p792ZJmrTzk/khRVTkHf4=";

  meta = with lib; {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = licenses.gpl3;
    maintainers = with maintainers; [ siraben nilsirl ];
  };
}
