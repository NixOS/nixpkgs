{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "v${version}";
    hash = "sha256-kOVmgST/D3zNOcGVu1ReuPuVrUx41iRK4rs59lqYX74=";
  };

  cargoHash = "sha256-0yrTPrxN/4TOALqpQ5GW7LXKisc8msx3DvEpg8uO+IQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
    substituteInPlace command-not-found.nu \
      --subst-var out
    install -Dm555 command-not-found.nu -t $out/etc/profile.d
  '';

  meta = with lib; {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      bennofs
      figsoda
      ncfavier
    ];
  };
}
