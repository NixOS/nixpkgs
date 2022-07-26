{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, libX11, libXcomposite, libXft, libXmu, libXrandr, libXext, libXScrnSaver
, pam, apacheHttpd, pamtester, xscreensaver, coreutils, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xsecurelock";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${version}";
    sha256 = "020y2mi4sshc5dghcz37aj5wwizbg6712rzq2a72f8z8m7mnxr5y";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config makeWrapper
  ];

  buildInputs = [
    libX11 libXcomposite libXft libXmu libXrandr libXext libXScrnSaver
    pam apacheHttpd pamtester
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

  postInstall = ''
    wrapProgram $out/libexec/xsecurelock/saver_blank --prefix PATH : ${coreutils}/bin
  '';

  meta = with lib; {
    description = "X11 screen lock utility with security in mind";
    homepage = "https://github.com/google/xsecurelock";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
