{ fetchFromGitHub, rustPlatform, lib, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c56na9s3g7rdb4cc6ccsnfby2ihf5zrfs3lg9qxiqsfr7mcn4w9";
  };

  cargoSha256 = "05rrww53g3k2c8mpxvyc067qsgs7w9sxnzdlvmca1idbqa0k9060";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk ];
  };
}
