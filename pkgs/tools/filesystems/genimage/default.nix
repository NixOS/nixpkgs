{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libconfuse, gettext }:

stdenv.mkDerivation rec {
  pname = "genimage";
  version = "18";

  src = fetchurl {
    url = "https://public.pengutronix.de/software/genimage/genimage-${version}.tar.xz";
    sha256 = "sha256-68P4hsTYAGTdbG1ePC6Y5aZwB4JkEIzi+Jraii4T/t0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libconfuse gettext ];

  postInstall = ''
    # As there is no manpage or built-in --help, add the README file for
    # documentation.
    docdir="$out/share/doc/genimage"
    mkdir -p "$docdir"
    cp -v README.rst "$docdir"
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://git.pengutronix.de/cgit/genimage";
    description = "Generate filesystem images from directory trees";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "genimage";
  };
}
