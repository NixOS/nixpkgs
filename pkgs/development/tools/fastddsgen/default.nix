{ lib, runtimeShell, fetchFromGitHub, gradle_7, openjdk17 }:
let
  pname = "fastddsgen";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-lxMv1hXjHFslJts63/FJPjj0mAKTluY/pNTvf15Oo9o=";
  };

  gradle = gradle_7;
in
gradle.buildPackage {
  inherit pname src version;

  gradleOpts = {
    depsHash = "sha256-/p3lWfFIjY82qw5vBvluYpFCGJuZ1t7JDsWg8LRBkrs=";
    lockfile = ./gradle.lockfile;
    buildscriptLockfile = ./buildscript-gradle.lockfile;
    flags = [ "--exclude-task" "submodulesUpdate" ];
  };

  nativeBuildInputs = [ openjdk17 ];
  # submodulesUpdate assemble

  installPhase = ''
    runHook preInstall

    "''${gradle[@]}" install --install_path=$out

    # Override the default start script to use absolute java path
    cat  <<EOF >$out/bin/fastddsgen
    #!${runtimeShell}
    exec ${openjdk17}/bin/java -jar "$out/share/fastddsgen/java/fastddsgen.jar" "\$@"
    EOF
    chmod a+x "$out/bin/fastddsgen"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast-DDS IDL code generator tool";
    homepage = "https://github.com/eProsima/Fast-DDS-Gen";
    license = licenses.asl20;
    longDescription = ''
      eProsima Fast DDS-Gen is a Java application that generates
      eProsima Fast DDS C++ or Python source code using the data types
      defined in an IDL (Interface Definition Language) file. This
      generated source code can be used in any Fast DDS application in
      order to define the data type of a topic, which will later be
      used to publish or subscribe.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = openjdk17.meta.platforms;
    /*
    Could not determine the dependencies of task ':idl-parser:jar'.
      > Could not resolve all files for configuration ':idl-parser:runtimeClasspath'.
         > Could not resolve org.antlr:antlr4:4.5.
           Required by:
               project :idl-parser
            > No cached version of org.antlr:antlr4:4.5 available for offline mode.
         > Could not resolve org.antlr:stringtemplate:3.2.
           Required by:
               project :idl-parser
               > No cached version of org.antlr:stringtemplate:3.2 available for offline mode.
    */
    broken = true;
  };
}
