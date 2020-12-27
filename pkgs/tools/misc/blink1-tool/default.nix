{ stdenv, fetchFromGitHub, libusb1, udev, pkg-config }:

stdenv.mkDerivation rec {
  pname = "blink1-tool";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "blink1-tool";
    rev = "v${version}";
    sha256 = "Wsbc6KAs804sx2Nhlqu1zXgZ1iX/44zNQQj32g2j7zQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 udev ];

  makeFlags = [ "GIT_TAG=v${version}" ];

  buildFlags = [ "blink1-tool" "lib" ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];
  installTargets = [ "install-lib" ];
  postInstall = ''
    install -D blink1-tool $out/bin/blink1-tool
  '';

  meta = with stdenv.lib; {
    description = "Command line client for the blink(1) notification light";
    homepage = "https://blink1.thingm.com/";
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ cransom ];
    platforms = platforms.linux;
  };
}
