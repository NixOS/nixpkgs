{ lib, python3, fetchFromGitHub }:
python3.pkgs.buildPythonApplication rec {
  pname = "joystickwake";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "foresto";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yhzv4gbz0c0ircxk91m1d4ygf14mla137z4nfxggmbvjs0aa4y0";
  };

  propagatedBuildInputs = with python3.pkgs; [ pyudev xlib ];

  meta = with lib; {
    description = "A joystick-aware screen waker";
    longDescription = ''
      Linux gamers often find themselves unexpectedly staring at a blank screen, because their display server fails to recognize game controllers as input devices, allowing the screen blanker to activate during gameplay.
      This program works around the problem by temporarily disabling screen blankers when joystick activity is detected.
    '';
    homepage = "https://github.com/foresto/joystickwake";
    maintainers = with maintainers; [ bertof ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
