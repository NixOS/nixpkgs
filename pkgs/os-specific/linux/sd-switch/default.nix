{ lib, fetchFromSourcehut, rustPlatform, nix-update-script }:

let version = "0.4.0";
in rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-PPFYH34HAD/vC+9jpA1iPQRVNR6MX8ncSPC+7bl2oHY=";
  };

  cargoHash = "sha256-zUoa7nPNFvnYekbEZwtnJKZ6qd47Sb4LZGEkaKVQ9ZQ=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
