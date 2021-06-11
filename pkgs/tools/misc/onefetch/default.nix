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

  cargoSha256 = "sha256-Bn2FlRESuW83ouGPiBwvGkIB0uCDDG0hdhRfRBks/0Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk ];
  };
}
