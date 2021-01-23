{ fetchFromGitHub, rustPlatform, lib, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-owa+HmzMXpLR7H1FssW4gQiVAQGJRXhcitgJj6pxJRc=";
  };

  cargoSha256 = "sha256-TqWe4eARQmmWcwnvb6BIZrzGeKMpiIObPv0cW1JvWj4=";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk ];
  };
}
