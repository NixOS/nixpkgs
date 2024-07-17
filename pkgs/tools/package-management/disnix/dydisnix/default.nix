{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  glib,
  libxml2,
  libxslt,
  getopt,
  libiconv,
  gettext,
  nix,
  disnix,
}:

stdenv.mkDerivation rec {
  version = "unstable-2020-11-02";
  pname = "dydisnix";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "dydisnix";
    rev = "12ca1516bc1e5d161ac68f5d8252a0a2f353c8cf";
    sha256 = "00f341274hwwil8mlgcgq331vfca9sscvpdbgkxsjvbhcqd8qa52";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    glib
    libxml2
    libxslt
    getopt
    nix
    disnix
    libiconv
    gettext
  ];

  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    description = "A toolset enabling self-adaptive redeployment on top of Disnix";
    longDescription = ''
      Dynamic Disnix is a (very experimental!) prototype extension framework for Disnix supporting dynamic (re)deployment of service-oriented systems.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.tomberek ];
    platforms = lib.platforms.unix;
  };
}
