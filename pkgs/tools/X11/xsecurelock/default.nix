{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, libXmu, libXrandr, libXext, libXScrnSaver
, pam, apacheHttpd, imagemagick, pamtester, xscreensaver, xset }:

stdenv.mkDerivation rec {
  pname = "xsecurelock";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "1if8byaby18ydkrk4k5yy8n0981x1dfqikq59gfpb7c2rv0vgi7i";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig
  ];
  buildInputs = [
    libX11 libXcomposite libXft libXmu libXrandr libXext libXScrnSaver
    pam apacheHttpd imagemagick pamtester
  ];

  configureFlags = [
    "--with-pam-service-name=login"
    "--with-xscreensaver=${xscreensaver}/libexec/xscreensaver"
  ];

  preConfigure = ''
    cat > version.c <<'EOF'
      const char *const git_version = "${version}";
    EOF
  '';

  meta = with lib; {
    description = "X11 screen lock utility with security in mind";
    homepage = https://github.com/google/xsecurelock;
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
