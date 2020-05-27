{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ifv1h16xrs40gw5wx7kwj7hirnzpgfrznskz2igsslk7ycjlbr1";
  };

  cargoSha256 = "1plx9p265jcc6wg3bhcdk1f77md8ann08kkv3g2706d82kxy2c1i";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  checkFlagsArray = [ "--skip=tests::cli" ];

  meta = with stdenv.lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ filalex77 ];
  };
}
