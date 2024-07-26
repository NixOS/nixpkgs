{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, Security
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

  cargoSha256 = "sha256-iuhJYibyQ7hdeXzqCW2PLq7FiKnZp2VHyKT4qO/6vrU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    homepage = "https://github.com/azur1s/octofetch";
    description = "Github user information on terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
    mainProgram = "octofetch";
  };
}
