{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y1mabnp0sbvayn695x1yfw04d2bky0r69wyidld6hllq3kqn9y2";
  };

  cargoSha256 = "1ra6argxs5dmpxhrr3az21myp27fl3nkdjfqn8cam2xhld1y270l";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.amar1729 ];
  };
}
