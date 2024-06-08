{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "keyfuzz";
  version = "0.2";

  meta = with lib; {
    description = "Manipulate the scancode/keycode translation tables of keyboard drivers";
    mainProgram = "keyfuzz";
    homepage    = "http://0pointer.de/lennart/projects/keyfuzz/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ mboes ];
  };

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/keyfuzz/keyfuzz-0.2.tar.gz";
    sha256 = "0xv9ymivp8fnyc5xcyh1vamxnx90bzw66wlld813fvm6q2gsiknk";
  };

  configureFlags = [ "--without-initdir" "--disable-lynx" ];
}
