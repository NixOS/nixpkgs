{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, sqlite
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "sha256-TDGtnSgY897fRm1BWLlQZQa8v6Wu5/JIF4UH+1CZm4U=";
  };

  cargoSha256 = "sha256-z1lLpZBD4HjO6gLw96wbucfchRgZs26Q8Gl+hpUB1xo=";

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
