{ lib, python3, fetchFromGitHub }:
python3.pkgs.buildPythonApplication rec {
  pname = "joystickwake";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "foresto";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j8xwfmzzmc9s88zvzc3lv67821r6x28vy6vli3srvx859wprppd";
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
