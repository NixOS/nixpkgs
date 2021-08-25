{ fetchFromGitHub
, rustPlatform
, lib
, stdenv
, fetchpatch
, CoreFoundation
, libiconv
, libresolv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lrRp01ZeK9bGn7L7SqAxJAU9qugpHnC06CWChhVPGGQ=";
  };

  cargoSha256 = "sha256-vNa1OF1x/MCTo9B4DTDZNWyHTsOl7Za3EgjnpsL/gWg=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk SuperSandro2000 ];
  };
}
