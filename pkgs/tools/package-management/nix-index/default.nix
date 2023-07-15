{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, sqlite
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "sha256-mdK63qRVvISRbRwfMel4SYucmBxR6RLbM4IFz3K3Pks=";
  };

  cargoHash = "sha256-uIGxCaFj4x1Ck/D2xxOlosJaGSVbOKxbXAEAkkBxyaQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl sqlite ]
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
