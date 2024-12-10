{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wayshot";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
    hash = "sha256-nUpIN4WTePtFZTmKAjv0tgj4VTdZeXjoQX6am9+M3ig=";
  };

  cargoHash = "sha256-1Y9ymodZHtxHzhudjGbkP2ohMaBMOD9K+GpUoNmzHQs=";

  # tests are off as they are broken and pr for integration testing is still WIP
  doCheck = false;

  meta = with lib; {
    description = "A native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      dit7ya
      id3v1669
    ];
    platforms = platforms.linux;
    mainProgram = "wayshot";
  };
}
