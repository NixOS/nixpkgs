{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, libXmu, pam, apacheHttpd, imagemagick
, pamtester, xscreensaver, xset }:

stdenv.mkDerivation rec {
  name = "xsecurelock-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "0yqp5xhkl9jpjyrmrxbyp7azwxmqc3lxv5lxrjqjaapl3q3096g5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    libX11 libXcomposite libXft libXmu pam
    apacheHttpd imagemagick pamtester
  ];

  configureFlags = [
    "--with-pam-service-name=login"
    "--with-xscreensaver=${xscreensaver}/libexec/xscreensaver"
  ];

  preInstall = ''
    substituteInPlace helpers/saver_blank \
      --replace 'protect xset' 'protect ${xset}/bin/xset'
  '';

  meta = with lib; {
    description = "X11 screen lock utility with security in mind";
    homepage = https://github.com/google/xsecurelock;
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
