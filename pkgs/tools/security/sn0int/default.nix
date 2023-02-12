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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+LplLeczLS+9EG0tZsiEs162/65zMCZfDDEq0iYQrGY=";
  };

  cargoHash = "sha256-FpoRO2g+R+Fo146kM0W8b1LHTEBHbGXURoX5jJk7lqY=";

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
