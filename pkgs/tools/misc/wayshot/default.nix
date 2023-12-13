{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "wayshot";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
    hash = "sha256-WN1qlV6vpIn0uNiE+rXeQTMscNYqkgFytVBc6gJzvyU=";
  };

  cargoHash = "sha256-Hfgr+wWC5zUdHhFMwOBt57h2r94OpdJ1MQpckhYgKQQ=";

  meta = with lib; {
    description = "A native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = licenses.bsd2;
    maintainers = [ maintainers.dit7ya ];
    platforms = platforms.linux;
    mainProgram = "wayshot";
  };
}
