{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXcomposite, libXft, libXmu, libXrandr, libXext, libXScrnSaver
, pam, apacheHttpd, imagemagick, pamtester, xscreensaver, xset }:

stdenv.mkDerivation rec {
  pname = "xsecurelock";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "1l9xk3hb5fxp4sqlxjldm4j6cvmxa39a7a37hw8f7vbpmcqy6n6w";
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
