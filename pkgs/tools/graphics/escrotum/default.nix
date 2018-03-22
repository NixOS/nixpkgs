{ lib, fetchFromGitHub, buildPythonApplication
, pygtk
, numpy ? null
}:

buildPythonApplication {
  name = "escrotum-2017-01-28";

  src = fetchFromGitHub {
    owner  = "Roger";
    repo   = "escrotum";
    rev    = "a51e330f976c1c9e1ac6932c04c41381722d2171";
    sha256 = "0vbpyihqgm0fyh22ashy4lhsrk67n31nw3bs14d1wr7ky0l3rdnj";
  };

  propagatedBuildInputs = [ pygtk numpy ];

  meta = with lib; {
    homepage = https://github.com/Roger/escrotum;
    description = "Linux screen capture using pygtk, inspired by scrot";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rasendubi ];
    license = licenses.gpl3;
  };
}
