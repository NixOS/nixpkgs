{ stdenv, fetchFromGitHub, rustPlatform, Security
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

  cargoSha256 = "1mksmdp1wnsjd8gw1g3l16a24fk05xa9mxygc0qklr41bqf8kw8b";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ amar1729 filalex77 ];
  };
}
