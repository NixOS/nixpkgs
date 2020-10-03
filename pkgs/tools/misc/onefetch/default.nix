{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3bERQ480SuvrjyqlBd9wnE4iIJAbN8HODUj0X+Uxrvs=";
  };

  cargoSha256 = "sha256-Bq2ytwbdhYeXIUM4tYSfUamhckraH5w34sAQ96ayJxI=";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
