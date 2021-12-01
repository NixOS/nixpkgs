{ lib, python2Packages, fetchFromGitHub
}:

with python2Packages; buildPythonApplication {
  pname = "escrotum";
  version = "unstable-2019-06-10";

  src = fetchFromGitHub {
    owner  = "Roger";
    repo   = "escrotum";
    rev    = "f6c300315cb4402e37f16b56aad2d206e24c5281";
    sha256 = "0x7za74lkwn3v6j9j04ifgdwdlx9akh1izkw7vkkzj9ag9qjrzb0";
  };

  propagatedBuildInputs = [ pygtk numpy ];

  outputs = [ "out" "man" ];

  postInstall = ''
    mkdir -p $man/share/man/man1
    cp man/escrotum.1 $man/share/man/man1/
  '';

  meta = with lib; {
    homepage = "https://github.com/Roger/escrotum";
    description = "Linux screen capture using pygtk, inspired by scrot";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rasendubi ];
    license = licenses.gpl3;
  };
}
