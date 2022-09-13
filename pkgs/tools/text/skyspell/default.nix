{
  fetchgit,
  lib,
  rustPlatform,
  hunspellDicts,
  hunspellWithDicts,
  enchant2,
  pkg-config,
  sqlite,
}:
rustPlatform.buildRustPackage rec {
  pname = "skyspell";
  version = "unstable-20220506";

  src = fetchgit {
    url = "https://git.sr.ht/~dmerej/skyspell";
    rev = "dc2a58e30963a2922555e42231266b00020dfb8f";
    sha256 = "sha256-3dHSZ/qCmm1qflYP/XBex9TftMZgUwaqHLjEMzS2j0w=";
  };

  cargoSha256 = "sha256-ofjqlENfZTspUjxbJx3PuhRxIVrZe397z+EKV6xDr/A=";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    (hunspellWithDicts [hunspellDicts.en-us])
  ];
  buildInputs = [
    (hunspellWithDicts [hunspellDicts.en-us])
    enchant2
    sqlite
  ];
  checkInputs = [
    (hunspellWithDicts [hunspellDicts.en-us])
  ];

  meta = with lib; {
    description = "Fast and handy spell checker for the command line";
    homepage = "https://git.sr.ht/~dmerej/skyspell";
    license = licenses.bsd3;
    maintainers = with maintainers; [mmlb];
  };
}
