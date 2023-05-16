<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libxml2
, nettle
, withGTK3 ? true
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "0.93";

  src = fetchFromGitHub {
    owner = "cernekee";
    repo = "stoken";
    rev = "v${version}";
    hash = "sha256-8N7TXdBu37eXWIKCBdaXVW0pvN094oRWrdlcy9raddI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxml2
    nettle
  ] ++ lib.optionals withGTK3 [
    gtk3
  ];
=======
{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config
, libxml2, nettle
, withGTK3 ? true, gtk3 }:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "0.92";
  src = fetchFromGitHub {
    owner = "cernekee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q7cv8vy5b2cslm57maqb6jsm7s4rwacjyv6gplwp26yhm38hw7y";
  };

  preConfigure = ''
    aclocal
    libtoolize --automake --copy
    autoheader
    automake --add-missing --copy
    autoconf
  '';

  strictDeps = true;
  nativeBuildInputs = [ pkg-config autoconf automake libtool ];
  buildInputs = [
    libxml2 nettle
  ] ++ lib.optional withGTK3 gtk3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Software Token for Linux/UNIX";
    homepage = "https://github.com/cernekee/stoken";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
