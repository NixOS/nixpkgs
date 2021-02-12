{ lib, stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c5bsqs6c55x4j640vhzlmbiylhp5agr7lx0jrwcjazfyvxihc01";
  };

  cargoSha256 = "1jkglvsb8kv1m8jdz7qmsiv696xycg8xih4vxibhj513sgr4pz36";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    maintainers = with maintainers; [ amar1729 Br1ght0ne ];
  };
}
