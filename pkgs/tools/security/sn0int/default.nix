{ lib
, fetchFromGitHub
, rustPlatform
, libsodium
, libseccomp
, sqlite
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ze4OFKUuc/t6tXgmoWFFDjpAQraSY6RIekkcDBctPJo=";
  };

  cargoHash = "sha256-PAKmoifqB1YC02fVF2SRbXAAGrMcB+Wlvr3FwuqmPVU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsodium
    libseccomp
    sqlite
  ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    changelog = "https://github.com/kpcyrd/sn0int/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab xrelkd ];
    platforms = platforms.linux;
  };
}
