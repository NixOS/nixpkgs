{ stdenv, fetchurl, cmake, wxGTK, openal, pkgconfig, curl, libtorrentRasterbar, libpng, libX11
, gettext, bash, gawk, boost, libnotify, gtk, doxygen, spring, makeWrapper }:
stdenv.mkDerivation rec {

  name = "springlobby-${version}";
  version = "0.180";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "0v2pwrwiwiggyl95rcyfj3pdlwsss5vcmnyzd40r9swb9gyi55na";
  };

  buildInputs = [
    cmake wxGTK openal pkgconfig curl gettext libtorrentRasterbar boost libpng libX11
    libnotify gtk doxygen makeWrapper
  ];

  patches = [ ./unitsync_path_find.patch ];

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
      --set SPRING_LIB_DIRS "${spring}/lib"
  '';

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
