{ fetchFromGitHub, rustPlatform, stdenv
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "02mdzpzfcxp9na86b4jcqqjd3id5jslgmnq1jc0vykg58xha51jg";
  };

  cargoSha256 = "1phv06zf47bv5cmhypivljfiynrblha0kj13c5al9l0hd1xx749h";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
