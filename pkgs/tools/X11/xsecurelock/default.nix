{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, pam, apacheHttpd, imagemagick
, pamtester, xscreensaver }:

stdenv.mkDerivation rec {
  name = "xsecurelock-git-2018-07-10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "0fa0d7dd87a4cc4bdb402323f95c3fcacc6f5049";
    sha256 = "071b3gslszql1mgabs53r82jgbk9mn263m5v6adskfxbkamks8g0";
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
