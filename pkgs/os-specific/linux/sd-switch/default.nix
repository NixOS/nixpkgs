{ lib, fetchFromSourcehut, rustPlatform, nix-update-script }:

let version = "0.5.0";
in rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-TESS+CwwEugAz+grzndunAoKF9Or/Jl7tftL392fUaM=";
  };

  cargoHash = "sha256-QEnleFwEIoKATupj0sSV/GUztQoozEsb3SEgnfFzAfw=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
