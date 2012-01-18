{ stdenv, fetchurl, unzip, SDL, libjpeg, zlib, libvorbis, curl }:
stdenv.mkDerivation rec {
  name = "xonotic-0.5.0";
  src = fetchurl {
    url = "http://dl.xonotic.org/${name}.zip";
    sha256 = "03vkbddffnz6ws3gkwc3qvi6icfsyiqq0dqw2vw5hj2kidm25rsq";
  };
  # Commented out things needed to build cl-release because of errors.
  #buildInputs = [ libX11 libXpm libXext xf86dgaproto libXxf86dga libXxf86vm mesa ];
  buildInputs = [ unzip SDL libjpeg ];
  sourceRoot = "Xonotic/source/darkplaces";
  #patchPhase = ''
  #  substituteInPlace glquake.h \
  #    --replace 'typedef char GLchar;' '/*typedef char GLchar;*/'
  #'';
  NIX_LDFLAGS="
    -rpath ${zlib}/lib
    -rpath ${libvorbis}/lib
    -rpath ${curl}/lib
  ";
  buildPhase = ''
    DP_FS_BASEDIR="$out/share/xonotic"
    #make DP_FS_BASEDIR=$DP_FS_BASEDIR cl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sdl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sv-release
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp darkplaces-dedicated "$out/bin/xonotic-dedicated"
    cp darkplaces-sdl "$out/bin/xonotic-sdl"
    cd ../..
    mkdir -p "$out/share/xonotic"
    mv data "$out/share/xonotic"
  '';
  dontPatchELF = true;
  meta = {
    description = "A free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, OS X and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = http://www.xonotic.org;
    license = with stdenv.lib.licenses; gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
