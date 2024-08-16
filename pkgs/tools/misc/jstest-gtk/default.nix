{ stdenv, lib, fetchFromGitLab, cmake, pkg-config, gtkmm3, libsigcxx, xorg }:

stdenv.mkDerivation rec {
  pname = "jstest-gtk";
  version = "2018-07-10";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "62f6e2d7d44620e503149510c428df9e004c9f3b";
    sha256 = "0icbbhrj5aqljhiavdy3hic60vp0zzfzyg0d6vpjaqkbzd5pv9d8";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ gtkmm3 libsigcxx xorg.libX11 ];

  meta = with lib; {
    description = "Simple joystick tester based on Gtk+";
    longDescription = ''
      It provides you with a list of attached joysticks, a way to display which
      buttons and axis are pressed, a way to remap axis and buttons and a way
      to calibrate your joystick.
    '';
    homepage = "https://jstest-gtk.gitlab.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
    mainProgram = "jstest-gtk";
  };
}
