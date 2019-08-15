{ stdenv, fetchzip, lib, makeWrapper, makeDesktopItem, jdk, gtk2, gawk }:

stdenv.mkDerivation rec {
  version = "1.4.3";
  pname = "visualvm";

  src = fetchzip {
    url = "https://github.com/visualvm/visualvm.src/releases/download/${version}/visualvm_${builtins.replaceStrings ["."] [""]  version}.zip";
    sha256 = "0pnziy24mdjnphvbw9wcjdxxc2bn7fqmsc19vabvfcck49w9rbvb";
  };

  desktopItem = makeDesktopItem {
      name = "visualvm";
      exec = "visualvm";
      comment = "Java Troubleshooting Tool";
      desktopName = "VisualVM";
      genericName = "Java Troubleshooting Tool";
      categories = "Application;Development;";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    find . -type f -name "*.dll" -o -name "*.exe"  -delete;

    substituteInPlace etc/visualvm.conf \
      --replace "#visualvm_jdkhome=" "visualvm_jdkhome=" \
      --replace "/path/to/jdk" "${jdk.home}" \
      --replace 'visualvm_default_options="' 'visualvm_default_options="--laf com.sun.java.swing.plaf.gtk.GTKLookAndFeel -J-Dawt.useSystemAAFontSettings=lcd -J-Dswing.aatext=true '

    substituteInPlace platform/lib/nbexec \
      --replace /usr/bin/\''${awk} ${gawk}/bin/awk

    cp -r . $out

    # To get the native LAF, JVM needs to see GTK’s .so-s.
    wrapProgram $out/bin/visualvm \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk2 ]}"
  '';

  meta = with stdenv.lib; {
    description = "A visual interface for viewing information about Java applications";
    longDescription = ''
      VisualVM is a visual tool integrating several commandline JDK
      tools and lightweight profiling capabilities. Designed for both
      production and development time use, it further enhances the
      capability of monitoring and performance analysis for the Java
      SE platform.
    '';
    homepage = https://visualvm.java.net/;
    license = licenses.gpl2ClasspathPlus;
    platforms = platforms.all;
    maintainers = with maintainers; [ michalrus moaxcp ];
  };
}
