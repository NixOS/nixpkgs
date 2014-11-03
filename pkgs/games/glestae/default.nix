x@{builderDefsPackage
  , mesa, cmake, lua5, SDL, openal, libvorbis, libogg, zlib, physfs
  , freetype, libpng, libjpeg, glew, wxGTK28, libxml2, libpthreadstubs
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="glestae";
    project="${baseName}";
    version="0.3.2";
    name="${baseName}-${version}";
    nameSuffix="-src";
    extension="tar.bz2";
    url="mirror://sourceforge/project/${project}/${version}/${baseName}${nameSuffix}-${version}.${extension}";
    hash="1k02vf88mms0zbprvy1b1qdwjzmdag5rd1p43f0gpk1sms6isn94";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall"];

  cmakeFlags = [
    "-DLUA_LIBRARIES=-llua"
    "-DGAE_DATA_DIR=$out/share/glestae"
  ];
      
  meta = {
    description = "A 3D RTS - fork of inactive Glest project";
    maintainers = [ a.lib.maintainers.raskin ];
    platforms = a.lib.platforms.linux;
    # Note that some data seems to be under separate redistributable licenses
    license = a.lib.licenses.gpl2Plus;
    broken = true;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/glestae/files/0.3.2/";
    };
  };
}) x

