{ lib, stdenv, fetchgit, pkg-config, ninja, libevdev, libev }:

stdenv.mkDerivation {
  version = "0.4";
  pname = "illum";

  src = fetchgit {
    url = "https://github.com/jmesmon/illum.git";
    fetchSubmodules = true;
    rev = "48ce8631346b1c88a901a8e4fa5fa7e8ffe8e418";
    sha256 = "05v3hz7n6b1mlhc6zqijblh1vpl0ja1y8y0lafw7mjdz03wxhfdb";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ninja libevdev libev ];

  configurePhase = ''
    bash ./configure
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv illum-d $out/bin
  '';

  meta = {
    homepage = "https://github.com/jmesmon/illum";
    description = "Daemon that wires button presses to screen backlight level";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dancek ];
    license = lib.licenses.agpl3;
  };
}
