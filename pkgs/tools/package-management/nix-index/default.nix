{ lib, rustPlatform, fetchFromGitHub, pkgconfig, openssl, curl }:

with rustPlatform;

buildRustPackage rec {
  name = "nix-index-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "1lmg65yqkwf2a5qxm3dmv8158kqhnriir062vlgar5wimf409rm5";
  };
  cargoSha256 = "0cxdrzjmqq3ywdh0f5mzkcf50hbbgd3bak4398v2ls5gy5s9fcz2";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl curl];

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = https://github.com/bennofs/nix-index;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.all;
  };
}
