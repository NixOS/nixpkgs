{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "octofetch";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "azur1s";
    repo = pname;
    rev = version;
    sha256 = "sha256-/AXE1e02NfxQzJZd0QX6gJDjmFFmuUTOndulZElgIMI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1lnHCiRktBGYb7Bgq4p60+kikb/LApPhzNp1O0Go46Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    homepage = "https://github.com/azur1s/octofetch";
    description = "Github user information on terminal";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "octofetch";
  };
}
