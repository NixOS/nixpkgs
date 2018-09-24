{ lib
, stdenv
, fetchFromGitHub

, autoreconfHook
, pkgconfig

, libX11
, libXcomposite
, libXft
, libXmu
, pam
, apacheHttpd
, imagemagick
, pamtester
, xscreensaver

# Extra modules to be copied into the derivation's helper directory;
# xsecurelock will only run modules from this directory, so they must be part
# of the derivation.
, extraModules ? []
}:

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

  # Allow adding extra modules to the helper directory
  postInstall =
    let
      copyHelper = path: "cp -v ${path} $out/libexec/xsecurelock/";
    in
      builtins.concatStringsSep "\n" (map copyHelper extraModules);

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
