{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
  pkg-config,
  taglib,
  libbass,
  libbass_fx,
}:

# TODO: get rid of (unfree) libbass
# issue:https://github.com/UltraStar-Deluxe/UltraStar-Creator/issues/3
# there’s a WIP branch here:
# https://github.com/UltraStar-Deluxe/UltraStar-Creator/commits/BASS_removed

mkDerivation {
  pname = "ultrastar-creator";
  version = "2019-04-23";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "UltraStar-Creator";
    rev = "36583b4e482b68f6aa949e77ef2744776aa587b1";
    sha256 = "1rzz04l7s7pxj74xam0cxlq569lfpgig35kpbsplq531d4007pc9";
  };

  postPatch = ''
    # we don’t want prebuild binaries checked into version control!
    rm -rf lib include
    sed -e "s|DESTDIR =.*$|DESTDIR = $out/bin|" \
        -e 's|-L".*unix"||' \
        -e "/QMAKE_POST_LINK/d" \
        -e "s|../include/bass|${lib.getLib libbass}/include|g" \
        -e "s|../include/bass_fx|${lib.getLib libbass_fx}/include|g" \
        -e "s|../include/taglib|${lib.getLib taglib}/include|g" \
        -i src/UltraStar-Creator.pro
  '';

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
  ];
  buildInputs = [
    qtbase
    taglib
    libbass
    libbass_fx
  ];

  meta = with lib; {
    description = "Ultrastar karaoke song creation tool";
    homepage = "https://github.com/UltraStar-Deluxe/UltraStar-Creator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ Profpatsch ];
  };
}
