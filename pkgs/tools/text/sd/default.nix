{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "15siv3p22v7lj37b74pjsy360qx97d40q2xdzdg2srbi8svjgg27";
  };

  cargoSha256 = "1sa7ki7kyg98l2gcrdzk7182ghm1clyqljjb596mhzh48g8kddn5";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.amar1729 ];
  };
}
