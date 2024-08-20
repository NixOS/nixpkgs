{ lib, fetchFromSourcehut, rustPlatform, nix-update-script }:

let version = "0.5.1";
in rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-Kns49Qv3oWNmbLoLTKIcWIewDz4cR7uyMA3IHnhKyxA=";
  };

  cargoHash = "sha256-r20dJMF+0q3XLm2hn9/LTv43ApmhjJNgeiMCLfwBnOk=";

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
