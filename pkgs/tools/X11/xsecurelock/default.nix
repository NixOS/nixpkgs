{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, pam, apacheHttpd, imagemagick
, pamtester, xscreensaver }:

stdenv.mkDerivation rec {
  name = "xsecurelock-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "0k135hnfnn1j82wvc03b8jkq06wws1xk325x5m25ps6xwsn725sw";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    libX11 libXcomposite libXft pam
    apacheHttpd imagemagick pamtester
  ];

  configureFlags = [
    "--with-pam-service-name=login"
    "--with-xscreensaver=${xscreensaver}/libexec/xscreensaver"
  ];

  meta = with lib; {
    description = "X11 screen lock utility with security in mind";
    homepage = https://github.com/google/xsecurelock;
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
