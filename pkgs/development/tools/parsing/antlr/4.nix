{ lib
, stdenv
, fetchurl
, jre
, fetchFromGitHub
, cmake
, ninja
, pkg-config

# darwin only
, CoreFoundation ? null

# ANTLR 4.8 & 4.9
, libuuid

# ANTLR 4.9
, utf8cpp
}:

let

  mkAntlr = {
    version, sourceHash, jarHash,
    extraCppBuildInputs ? [],
    extraCppCmakeFlags ? [],
    extraPatches ? [ ]
  }: rec {
    source = fetchFromGitHub {
      owner = "antlr";
      repo = "antlr4";
      rev = version;
      hash = sourceHash;
    };

    antlr = stdenv.mkDerivation {
      pname = "antlr";
      inherit version;

      src = fetchurl {
        url = "https://www.antlr.org/download/antlr-${version}-complete.jar";
        hash = jarHash;
      };

      dontUnpack = true;

      installPhase = ''
        mkdir -p "$out"/{share/java,bin}
        ln -s "$src" "$out/share/java/antlr-${version}-complete.jar"

        echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.Tool \"\$@\"" >> "$out/bin/antlr"

        echo "#! ${stdenv.shell}" >> "$out/bin/antlr-parse"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.gui.Interpreter \"\$@\"" >> "$out/bin/antlr-parse"

        echo "#! ${stdenv.shell}" >> "$out/bin/grun"
        echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' org.antlr.v4.gui.TestRig \"\$@\"" >> "$out/bin/grun"

        chmod a+x "$out/bin/antlr" "$out/bin/antlr-parse" "$out/bin/grun"
        ln -s "$out/bin/antlr"{,4}
        ln -s "$out/bin/antlr"{,4}-parse
      '';

      inherit jre;

      passthru = {
        inherit runtime;
        jarLocation = antlr.src;
      };

      meta = with lib; {
        description = "Powerful parser generator";
        longDescription = ''
          ANTLR (ANother Tool for Language Recognition) is a powerful parser
          generator for reading, processing, executing, or translating structured
          text or binary files. It's widely used to build languages, tools, and
          frameworks. From a grammar, ANTLR generates a parser that can build and
          walk parse trees.
        '';
        homepage = "https://www.antlr.org";
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = licenses.bsd3;
        platforms = platforms.unix;
      };
    };

    runtime = {
      cpp = stdenv.mkDerivation {
        pname = "antlr-runtime-cpp";
        inherit version;
        src = source;

        patches = extraPatches;

        outputs = [ "out" "dev" "doc" ];

        nativeBuildInputs = [ cmake ninja pkg-config ];
        buildInputs =
          lib.optional stdenv.isDarwin CoreFoundation ++
          extraCppBuildInputs;

        cmakeDir = "../runtime/Cpp";

        cmakeFlags = extraCppCmakeFlags;

        meta = with lib; {
          description = "C++ target for ANTLR 4";
          homepage = "https://www.antlr.org/";
          license = licenses.bsd3;
          platforms = platforms.unix;
        };
      };
    };
  };

in {
  antlr4_13 = (mkAntlr {
    version = "4.13.1";
    sourceHash = "sha256-ky9nTDaS+L9UqyMsGBz5xv+NY1bPavaSfZOeXO1geaA=";
    jarHash = "sha256-vBOpxXqN19UZaIghHl7eZXy2SjzpaGCGl+T2aCUahIc=";
    extraCppCmakeFlags = [
      # Generate CMake config files, which are not installed by default.
      "-DANTLR4_INSTALL=ON"

      # Disable tests, since they require downloading googletest, which is
      # not available in a sandboxed build.
      "-DANTLR_BUILD_CPP_TESTS=OFF"
    ];
  }).antlr;

  antlr4_12 = (mkAntlr {
    version = "4.12.0";
    sourceHash = "sha256-0JMG8UYFT+IAWvARY2KnuXSr5X6LlVZN4LJHy5d4x08=";
    jarHash = "sha256-iPGKK/rA3eEAntpcfc41ilKHf673ho9WIjpbzBUynkM=";
    extraCppCmakeFlags = [
      # Generate CMake config files, which are not installed by default.
      "-DANTLR4_INSTALL=ON"

      # Disable tests, since they require downloading googletest, which is
      # not available in a sandboxed build.
      "-DANTLR_BUILD_CPP_TESTS=OFF"
    ];
  }).antlr;

  antlr4_11 = (mkAntlr {
    version = "4.11.1";
    sourceHash = "sha256-SUeDgfqLjYQorC8r/CKlwbYooTThMOILkizwQV8pocc=";
    jarHash = "sha256-YpdeGStK8mIrcrXwExVT7jy86X923CpBYy3MVeJUc+E=";
    extraCppCmakeFlags = [
      # Generate CMake config files, which are not installed by default.
      "-DANTLR4_INSTALL=ON"

      # Disable tests, since they require downloading googletest, which is
      # not available in a sandboxed build.
      "-DANTLR_BUILD_CPP_TESTS=OFF"
    ];
  }).antlr;

  antlr4_10 = (mkAntlr {
    version = "4.10.1";
    sourceHash = "sha256-Z1P81L0aPbimitzrHH/9rxsMCA6Qn3i42jFbUmVqu1E=";
    jarHash = "sha256-QZSdQfINMdW4J3GHc13XVRCN9Ss422yGUQjTOCBA+Rg=";
    extraCppBuildInputs = lib.optional stdenv.isLinux libuuid;
    extraCppCmakeFlags = [
      "-DANTLR4_INSTALL=ON"
      "-DANTLR_BUILD_CPP_TESTS=OFF"
    ];
  }).antlr;

  antlr4_9 = (mkAntlr {
    version = "4.9.3";
    sourceHash = "sha256-FQeb1P9/QLZtw9leWvnx0DshEqgqQI3LCpieybFjw6k=";
    jarHash = "sha256-r81AlG095NgeKNfIjUZyieBYcoXSetsXKuzFSUoX3zY=";
    extraCppBuildInputs = [ utf8cpp ]
      ++ lib.optional stdenv.isLinux libuuid;
    extraCppCmakeFlags = [
      "-DCMAKE_CXX_FLAGS='-I${lib.getDev utf8cpp}/include/utf8cpp'"
    ];
    extraPatches = [
      ./utf8cpp.patch
    ];
  }).antlr;

  antlr4_8 = (mkAntlr {
    version = "4.8";
    sourceHash = "sha256-Fcm017rVfkhhtVF6lottimaFysln2oLq1B0b0ZoaVOE=";
    jarHash = "sha256-c6SdaBDZA6pIJ+4yEmk3uF076+wKjmebDdljy8xJulo=";
    extraCppBuildInputs = lib.optional stdenv.isLinux libuuid;
    extraCppCmakeFlags = [ "-DANTLR4_INSTALL=ON" ];
  }).antlr;
}
