{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ibus,
  gtk3,
  libthai,
}:

stdenv.mkDerivation rec {
  pname = "ibus-libthai";
  version = "0.1.5";

  src = fetchurl {
    url = "https://linux.thai.net/pub/ThaiLinux/software/libthai/ibus-libthai-${version}.tar.xz";
    sha256 = "sha256-egAxttjwuKiDoIuJluoOTJdotFZJe6ZOmJgdiFCAwx0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    ibus
    libthai
  ];

  meta = with lib; {
    isIbusEngine = true;
    homepage = "https://linux.thai.net/projects/ibus-libthai";
    description = "Thai input method engine for IBus";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
