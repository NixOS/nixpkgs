{ stdenv, fetchFromGitHub
, qmake, qtbase, pkgconfig, taglib, libbass, libbass_fx }:

stdenv.mkDerivation rec {
  name = "ultrastar-creator-${version}";
  version = "2017-04-12";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "UltraStar-Creator";
    rev = "ac519a003f8283bfbe5e2d8e9cdff3a3faf97001";
    sha256 = "00idr8a178gvmylq722n13bli59kpxlsy5d8hlplqn7fih48mnzi";
  };

  postPatch = with stdenv.lib; ''
    # we don’t want prebuild binaries checked into version control!
    rm -rf lib include
    sed -e "s|DESTDIR =.*$|DESTDIR = $out/bin|" \
        -e 's|-L".*unix"||' \
        -e "/QMAKE_POST_LINK/d" \
        -e "s|../include/bass|${getLib libbass}/include|g" \
        -e "s|../include/bass_fx|${getLib libbass_fx}/include|g" \
        -e "s|../include/taglib|${getLib taglib}/include|g" \
        -i src/UltraStar-Creator.pro
  '';

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase taglib libbass libbass_fx ];

  meta = with stdenv.lib; {
    description = "Ultrastar karaoke song creation tool";
    homepage = https://github.com/UltraStar-Deluxe/UltraStar-Creator;
    license = licenses.gpl2;
    maintainers = with maintainers; [ profpatsch ];
  };
}
