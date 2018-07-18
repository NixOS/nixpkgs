{ lib, rustPlatform, fetchFromGitHub, pkgconfig, openssl, curl }:

with rustPlatform;

buildRustPackage rec {
  name = "nix-index-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "17pms3cq3i3jan1irxgqfr3nrjy6zb21y07pwqp9v08hyrjpfqin";
  };
  cargoSha256 = "0b7xwcgjds80g08sx91lqip8syb52n458si4q4xycvvsand5fa10";
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
