{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, sqlite
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "arti";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
    sha256 = "sha256-A5enH7JqnLZ9Tte+FMpMVqq1g1JveYJbzH1Qum5In5E=";
  };

  cargoHash = "sha256-LVc7CgRS57p7TUaTo8L94YArYC7eI0wegzNMcTiJrEg=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ sqlite ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoBuildFlags = [ "--package" "arti" ];

  cargoTestFlags = [ "--package" "arti" ];

  meta = with lib; {
    description = "An implementation of Tor in Rust";
    homepage = "https://gitlab.torproject.org/tpo/core/arti";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/raw/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ marsam ];
  };
}
