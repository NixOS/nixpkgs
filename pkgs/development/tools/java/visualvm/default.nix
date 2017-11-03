{ stdenv, fetchzip, lib, makeWrapper, jdk, gtk2, gawk }:

stdenv.mkDerivation rec {
  name = "visualvm-1.3.9";

  src = fetchzip {
    url = "https://github.com/visualvm/visualvm.src/releases/download/1.3.9/visualvm_139.zip";
    sha256 = "1gkdkxssh51jczhgv680i42jjrlia1vbpcqhxvf45xcq9xj95bm5";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/visualvm.exe
    rm platform/lib/nbexec64.exe
    rm platform/lib/nbexec.exe
    rm profiler/lib/deployed/jdk15/windows-amd64/profilerinterface.dll
    rm profiler/lib/deployed/jdk15/windows/profilerinterface.dll
    rm profiler/lib/deployed/jdk16/windows-amd64/profilerinterface.dll
    rm profiler/lib/deployed/jdk16/windows/profilerinterface.dll
    rm platform/modules/lib/amd64/jnidispatch-410.dll
    rm platform/modules/lib/x86/jnidispatch-410.dll
    rm platform/lib/nbexec.dll
    rm platform/lib/nbexec64.dll

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
    maintainers = with maintainers; [ michalrus ];
  };
}
