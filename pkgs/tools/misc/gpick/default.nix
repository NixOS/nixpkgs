{ stdenv
, fetchFromGitHub
, cmake
, wrapGAppsHook
, boost
, pkg-config
, gtk3
, ragel
, lua
, fetchpatch
, lib
}:

stdenv.mkDerivation rec {
  pname = "gpick";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "thezbyg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Z17YpdAAr2wvDFkrAosyCN6Y/wsFVkiB9IDvXuP9lYo=";
  };

  patches = [
    # gpick/cmake/Version.cmake
    ./dot-version.patch

    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/1d53a9aace4bb60300e52458bb1577d248cb87cd/trunk/buildfix.diff";
      hash = "sha256-DnRU90VPyFhLYTk4GPJoiVYadJgtYgjMS4MLgmpYLP0=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];
  buildInputs = [ boost gtk3 ragel lua ];

  meta = with lib; {
    description = "Advanced color picker written in C++ using GTK+ toolkit";
    homepage = "http://www.gpick.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
  };
}
