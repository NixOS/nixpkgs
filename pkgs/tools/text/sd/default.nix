{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = version;
    sha256 = "1vxljmd1vh245yhv095i3l44pk915zr2pix4v9r8pz2fynp2nnmj";
  };

  cargoSha256 = "0n4c0snmjfyk3z2mbzpqgb6ggyv4nqszdda035g3rzpbavzx9xb5";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.amar1729 ];
  };
}
