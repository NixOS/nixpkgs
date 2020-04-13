{ stdenv, fetchFromGitHub, go-md2man, installShellFiles, libusb }:

stdenv.mkDerivation rec {
  pname = "teensy-loader-cli";
  version = "2.1.20191110";

  src = fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "teensy_loader_cli";
    rev = "e98b5065cdb9f04aa4dde3f2e6e6e6f12dd97592";
    sha256 = "1yx8vsh6b29pqr4zb6sx47429i9x51hj9psn8zksfz75j5ivfd5i";
  };

  buildInputs = [ libusb ];

  nativeBuildInputs = [ go-md2man installShellFiles ];

  installPhase = ''
    install -Dm555 teensy_loader_cli $out/bin/teensy-loader-cli
    install -Dm444 -t $out/share/doc/${pname} *.md *.txt
    go-md2man -in README.md -out ${pname}.1
    installManPage *.1
  '';

  meta = with stdenv.lib; {
    description = "Firmware uploader for the Teensy microcontroller boards";
    homepage = "https://www.pjrc.com/teensy/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
