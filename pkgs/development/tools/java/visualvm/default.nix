{ stdenv, fetchzip, lib, makeWrapper, makeDesktopItem, jdk }:

stdenv.mkDerivation rec {
  version = "2.1.9";
  pname = "visualvm";

  src = fetchzip {
    url = "https://github.com/visualvm/visualvm.src/releases/download/${version}/visualvm_${builtins.replaceStrings ["."] [""]  version}.zip";
    sha256 = "sha256-q1oIxdeCQq7JdVskjvF2KAFzFGrowRHjkvst3ukXSyY=";
  };

  desktopItem = makeDesktopItem {
      name = "visualvm";
      exec = "visualvm";
      comment = "Java Troubleshooting Tool";
      desktopName = "VisualVM";
      genericName = "Java Troubleshooting Tool";
      categories = [ "Development" ];
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    find . -type f -name "*.dll" -o -name "*.exe"  -delete;

    substituteInPlace etc/visualvm.conf \
      --replace "#visualvm_jdkhome=" "visualvm_jdkhome=" \
      --replace "/path/to/jdk" "${jdk.home}" \

    cp -r . $out
  '';

  meta = with lib; {
    description = "Visual interface for viewing information about Java applications";
    mainProgram = "visualvm";
    longDescription = ''
      VisualVM is a visual tool integrating several commandline JDK
      tools and lightweight profiling capabilities. Designed for both
      production and development time use, it further enhances the
      capability of monitoring and performance analysis for the Java
      SE platform.
    '';
    homepage = "https://visualvm.github.io";
    license = licenses.gpl2ClasspathPlus;
    platforms = platforms.all;
    maintainers = with maintainers; [ michalrus moaxcp ];
  };
}
