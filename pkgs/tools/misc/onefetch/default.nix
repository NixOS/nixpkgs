{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9HZLr/dwr5T1m6H/SHy9ULfKMkyrLNb2Z8W3RlSWzGM=";
  };

  cargoSha256 = "sha256-cyffVX1XEF5zaNbk/VeZEtKG/Npwv5Yzz9OU5G9UyGc=";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 kloenk ];
  };
}
