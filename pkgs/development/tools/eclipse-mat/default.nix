{ fetchurl
, fontconfig
, freetype
, glib
, gsettings-desktop-schemas
, gtk3
, jdk11
, lib
, libX11
, libXrender
, libXtst
, makeDesktopItem
, makeWrapper
, shared-mime-info
, stdenv
, unzip
, webkitgtk
, zlib
}:

with lib;
let
  pVersion = "1.12.0.20210602";
  pVersionTriple = splitVersion pVersion;
  majorVersion = elemAt pVersionTriple 0;
  minorVersion = elemAt pVersionTriple 1;
  patchVersion = elemAt pVersionTriple 2;
  baseVersion = "${majorVersion}.${minorVersion}.${patchVersion}";
  jdk = jdk11;
in
stdenv.mkDerivation rec {
  pname = "eclipse-mat";
  version = pVersion;

  src = fetchurl {
    url = "http://ftp.halifax.rwth-aachen.de/eclipse//mat/${baseVersion}/rcp/MemoryAnalyzer-${version}-linux.gtk.x86_64.zip";
    sha256 = "sha256-qX4RPuZdeiEduJAEpzOi/QnbJ+kaD0PZ3WHrmGsvqHc=";
  };

  desktopItem = makeDesktopItem {
    name = "eclipse-mat";
    exec = "eclipse-mat";
    icon = "eclipse";
    comment = "Eclipse Memory Analyzer";
    desktopName = "Eclipse MAT";
    genericName = "Java Memory Analyzer";
    categories = [ "Development" ];
  };

  unpackPhase = ''
    unzip $src
  '';

  buildCommand = ''
    mkdir -p $out
    unzip $src
    mv mat $out

    # Patch binaries.
    interpreter=$(echo ${stdenv.cc.libc}/lib/ld-linux*.so.2)
    libCairo=$out/eclipse/libcairo-swt.so
    patchelf --set-interpreter $interpreter $out/mat/MemoryAnalyzer
    [ -f $libCairo ] && patchelf --set-rpath ${
      lib.makeLibraryPath [ freetype fontconfig libX11 libXrender zlib ]
    } $libCairo

    # Create wrapper script.  Pass -configuration to store settings in ~/.eclipse-mat/<version>
    makeWrapper $out/mat/MemoryAnalyzer $out/bin/eclipse-mat \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib gtk3 libXtst webkitgtk ])} \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse-mat/''${version}/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    find $out/mat/plugins -name 'eclipse*.png' -type f -exec cp {} $out/share/pixmaps \;
    mv $out/share/pixmaps/eclipse64.png $out/share/pixmaps/eclipse.png
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    fontconfig
    freetype
    glib
    gsettings-desktop-schemas
    gtk3
    jdk
    libX11
    libXrender
    libXtst
    makeWrapper
    zlib
    shared-mime-info
    webkitgtk
  ];

  dontBuild = true;
  dontConfigure = true;

  meta = with lib; {
    description = "Fast and feature-rich Java heap analyzer";
    longDescription = ''
      The Eclipse Memory Analyzer is a tool that helps you find memory
      leaks and reduce memory consumption. Use the Memory Analyzer to
      analyze productive heap dumps with hundreds of millions of
      objects, quickly calculate the retained sizes of objects, see
      who is preventing the Garbage Collector from collecting objects,
      run a report to automatically extract leak suspects.
    '';
    homepage = "https://www.eclipse.org/mat";
    license = licenses.epl20;
    maintainers = [ maintainers.ktor ];
    platforms = [ "x86_64-linux" ];
  };

}
