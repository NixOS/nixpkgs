{ stdenv, lib, pkgconfig, openssl, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "hydra-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jdlmc45hwblcxs6hvy3gi2dr7qyzs1sg5zr26jrpxrbvqqzrdhc";
  };

  cargoSha256 = "11y82np52f7lgfzhzs24kkawcfzzc6070x4rj5d6iv5csf6c03ny";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [
    pkgconfig
    openssl
  ];

  meta = with stdenv.lib; {
    description = "A client for the Hydra CI";
    homepage = "https://github.com/nlewo/hydra-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gilligan lewo ];
    platforms = platforms.all;
  };

}
