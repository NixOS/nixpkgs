{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, libXmu, libXrandr, libXext, libXScrnSaver
, pam, apacheHttpd, imagemagick, pamtester, xscreensaver, xset }:

stdenv.mkDerivation rec {
  name = "xsecurelock-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "17666b0ah5pfspxbfx9cw3lfmzx6b47r54bacwzzhfq6wbw6ci6k";
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
