{ stdenv, fetchurl, cmake, wxGTK, openal, pkgconfig, curl, libtorrentRasterbar, libpng, libX11
, gettext, bash, gawk, boost, libnotify, gtk, doxygen, spring, makeWrapper }:
stdenv.mkDerivation rec {

  name = "springlobby-${version}";
  version = "0.195";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "0hxxm97c74rvm78vlfn2byn0zjlrhankxdrs2hz73rdq6451h10b";
  };

  buildInputs = [
    cmake wxGTK openal pkgconfig curl gettext libtorrentRasterbar
    boost libpng libX11 libnotify gtk doxygen makeWrapper
  ];

  prePatch = ''
    substituteInPlace tools/regen_config_header.sh --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace tools/test-susynclib.awk --replace "#!/usr/bin/awk" "#!${gawk}/bin/awk"
    substituteInPlace CMakeLists.txt --replace "boost_system-mt" "boost_system"
  '';

  # for now sound is disabled as it causes a linker error with alure i can't resolve (qknight)
  cmakeFlags = "-DOPTION_SOUND:BOOL=OFF"; 

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/springlobby \
      --prefix PATH : "${spring}/bin" \
      --set SPRING_BUNDLE_DIR "${spring}/lib"
  '';

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    repositories.git = git://github.com/springlobby/springlobby.git;
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight iElectric ];
    platforms = platforms.linux;
  };
}
