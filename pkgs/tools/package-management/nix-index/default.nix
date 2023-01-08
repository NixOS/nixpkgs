{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "unstable-2023-01-03";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "36ff1aac466392fb2d7043fd3e196667a531374b";
    sha256 = "sha256-QXUqz7SiUBDOBKiALdtWNEPhS/EAM8pEEtazGcTCzvM=";
  };

  cargoSha256 = "sha256-ELlgbE5dR3a6yRTRD88tgEs4gtN1N3M2nBjVFu6GMwc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl ]
    ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
  };
}
