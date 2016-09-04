{ stdenv, fetchzip, lib, makeWrapper, jdk, gtk }:

stdenv.mkDerivation rec {
  name = "visualvm-1.3.8";

  src = fetchzip {
    url = "https://java.net/projects/visualvm/downloads/download/release138/visualvm_138.zip";
    sha256 = "09wsi85z1g7bwyfhb37vw0gy3wl0j1cy35aj59rg7067q262gy1y";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/visualvm.exe

    substituteInPlace etc/visualvm.conf \
      --replace "#visualvm_jdkhome=" "visualvm_jdkhome=" \
      --replace "/path/to/jdk" "${jdk.home}" \
      --replace 'visualvm_default_options="' 'visualvm_default_options="--laf com.sun.java.swing.plaf.gtk.GTKLookAndFeel -J-Dawt.useSystemAAFontSettings=lcd -J-Dswing.aatext=true '

    cp -r . $out

    # To get the native LAF, JVM needs to see GTK’s .so-s.
    wrapProgram $out/bin/visualvm \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk ]}"
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
    maintainers = with maintainers; [ michalrus ];
  };
}
