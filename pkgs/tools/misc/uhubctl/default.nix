{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "v${version}";
    sha256 = "sha256-Rt9hTT0Tn8v+J1XqZm8iXTTY4nKow2qjRPNmNCiWNoY=";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "uhubctl";
  };
}
