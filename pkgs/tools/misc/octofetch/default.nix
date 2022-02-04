{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
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

  cargoSha256 = "sha256:1ddyzbpsiy54r13nb9yrm64cbbifixnhkskwg5fvhhzj4ri4ks4a";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Github user information on terminal";
    homepage = "https://github.com/azur1s/octofetch";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
