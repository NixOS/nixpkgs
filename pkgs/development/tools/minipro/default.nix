{ stdenv, installShellFiles, fetchFromGitLab, pkg-config, libusb1 }:
stdenv.mkDerivation rec {
  pname = "minipro";
  version = "0.4";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "minipro";
    rev = version;
    sha256 = "17k2vanz0xrmvl5sa12jr1n4x5m2s7292qs79mvj40bxbhrcmaci";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libusb1
  ];

  preConfigure = ''
    export PKG_CONFIG="${pkg-config}/bin/pkg-config";
    substituteInPlace Makefile --replace '$(shell date "+%Y-%m-%d %H:%M:%S %z")' "1970-01-01 00:00:00 +0000"
  '';

  makeFlags = [ "-e minipro" ];

  installPhase = ''
    mkdir $out/bin $out/lib/udev/rules.d -pv
    cp -rv ./minipro $out/bin/
    mv udev/* $out/lib/udev/rules.d/ -v
    installManPage ./man/minipro.1
    installShellCompletion --bash ./bash_completion.d/minipro
  '';

  meta = with stdenv.lib; {
    description = "An open source program for controlling the MiniPRO TL866xx series of chip programmers";
    homepage = "https://gitlab.com/DavidGriffith/minipro";
    maintainers = with maintainers; [ kalium ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
