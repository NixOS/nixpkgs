{ lib, rustPlatform, fetchFromGitHub, pkg-config, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = version;
    sha256 = "n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoSha256 = "8ZMdbJvedDqoDr2rhKM1TMB5N4aRde04x/9H212fe68=";

  meta = with lib; {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ DPDmancul ];
  };
}
