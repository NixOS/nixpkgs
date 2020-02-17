{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dkkbyzimnzfyrzmfn83jqg5xq53wzrknixnyh46cniqffqhd663";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0ji6d5a23rzhkkk27iigqcf2zw3mx1p1ap0cryqcj43z5ixdygiw";

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
