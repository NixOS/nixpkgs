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

  cargoSha256 = "1iwgy9zzdxay6hb9pz47jchy03jrsy5csxijlq4i228qhqnvq1lr";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    maintainers = with maintainers; [ amar1729 Br1ght0ne ];
  };
}
