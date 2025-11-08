{
  lib,
  stdenv,
  fetchurl,
  jre,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,

  # darwin only
  CoreFoundation ? null,

  # ANTLR 4.8 & 4.9
  libuuid,

  # ANTLR 4.9
  utf8cpp,
}:

let

  mkAntlr =
    {
      version,
      sourceSha256,
      jarSha256,
      extraCppBuildInputs ? [ ],
      extraCppCmakeFlags ? [ ],
      extraPatches ? [ ],
    }:
    rec {
      source = fetchFromGitHub {
        owner = "antlr";
        repo = "antlr4";
        tag = version;
        sha256 = sourceSha256;
      };

      antlr = stdenv.mkDerivation {
        pname = "antlr";
        inherit version;

        src = fetchurl {
          url = "https://www.antlr.org/download/antlr-${version}-complete.jar";
          sha256 = jarSha256;
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

        meta = {
          description = "Powerful parser generator";
          longDescription = ''
            ANTLR (ANother Tool for Language Recognition) is a powerful parser
            generator for reading, processing, executing, or translating structured
            text or binary files. It's widely used to build languages, tools, and
            frameworks. From a grammar, ANTLR generates a parser that can build and
            walk parse trees.
          '';
          homepage = "https://www.antlr.org/";
          sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
          license = lib.licenses.bsd3;
          platforms = lib.platforms.unix;
          maintainers = with lib.maintainers; [ sarahec ];
        };
      };

      runtime = {
        cpp = stdenv.mkDerivation {
          pname = "antlr-runtime-cpp";
          inherit version;
          src = source;

          patches = extraPatches;

          outputs = [
            "out"
            "dev"
            "doc"
          ];

          nativeBuildInputs = [
            cmake
            ninja
            pkg-config
          ];
          buildInputs = extraCppBuildInputs;

          cmakeDir = "../runtime/Cpp";

          cmakeFlags = extraCppCmakeFlags;

          meta = {
            description = "C++ target for ANTLR 4";
            homepage = "https://www.antlr.org/";
            license = lib.licenses.bsd3;
            platforms = lib.platforms.unix;
            maintainers = with lib.maintainers; [ sarahec ];
          };
        };
      };
    };

in
{
  antlr4_13 =
    (mkAntlr {
      version = "4.13.2";
      sourceSha256 = "sha256-DxxRL+FQFA+x0RudIXtLhewseU50aScHKSCDX7DE9bY=";
      jarSha256 = "sha256-6uLfoRmmQydERnKv9j6ew1ogGA3FuAkLemq4USXfTXY=";
      extraCppCmakeFlags = [
        # Generate CMake config files, which are not installed by default.
        (lib.cmakeBool "ANTLR4_INSTALL" true)

        # Disable tests, since they require downloading googletest, which is
        # not available in a sandboxed build.
        (lib.cmakeBool "ANTLR_BUILD_CPP_TESTS" false)
      ];
      extraPatches = [
        ./include-dir-issue-379757.patch
      ];
    }).antlr;

  antlr4_12 =
    (mkAntlr {
      version = "4.12.0";
      sourceSha256 = "sha256-0JMG8UYFT+IAWvARY2KnuXSr5X6LlVZN4LJHy5d4x08=";
      jarSha256 = "sha256-iPGKK/rA3eEAntpcfc41ilKHf673ho9WIjpbzBUynkM=";
      extraCppCmakeFlags = [
        # Generate CMake config files, which are not installed by default.
        (lib.cmakeBool "ANTLR4_INSTALL" true)

        # Disable tests, since they require downloading googletest, which is
        # not available in a sandboxed build.
        (lib.cmakeBool "ANTLR_BUILD_CPP_TESTS" false)
      ];
    }).antlr;

  antlr4_11 =
    (mkAntlr {
      version = "4.11.1";
      sourceSha256 = "sha256-SUeDgfqLjYQorC8r/CKlwbYooTThMOILkizwQV8pocc=";
      jarSha256 = "sha256-YpdeGStK8mIrcrXwExVT7jy86X923CpBYy3MVeJUc+E=";
      extraCppCmakeFlags = [
        # Generate CMake config files, which are not installed by default.
        (lib.cmakeBool "ANTLR4_INSTALL" true)

        # Disable tests, since they require downloading googletest, which is
        # not available in a sandboxed build.
        (lib.cmakeBool "ANTLR_BUILD_CPP_TESTS" false)
      ];
      extraPatches = [
        ./4.11.runtime.cpp.cmake.patch
      ];
    }).antlr;

  antlr4_10 =
    (mkAntlr {
      version = "4.10.1";
      sourceSha256 = "sha256-Z1P81L0aPbimitzrHH/9rxsMCA6Qn3i42jFbUmVqu1E=";
      jarSha256 = "sha256-QZSdQfINMdW4J3GHc13XVRCN9Ss422yGUQjTOCBA+Rg=";
      extraCppBuildInputs = lib.optional stdenv.hostPlatform.isLinux libuuid;
      extraCppCmakeFlags = [
        (lib.cmakeBool "ANTLR4_INSTALL" true)
        (lib.cmakeBool "ANTLR_BUILD_CPP_TESTS" false)
      ];
      extraPatches = [
        ./4.10.runtime.cpp.cmake.patch
      ];
    }).antlr;

  antlr4_9 =
    (mkAntlr {
      version = "4.9.3";
      sourceSha256 = "1af3cfqwk7lq1b5qsh1am0922fyhy7wmlpnrqdnvch3zzza9n1qm";
      jarSha256 = "0dnz2x54kigc58bxnynjhmr5iq49f938vj6p50gdir1xdna41kdg";
      extraCppBuildInputs = [ utf8cpp ] ++ lib.optional stdenv.hostPlatform.isLinux libuuid;
      extraCppCmakeFlags = [
        (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-I${lib.getDev utf8cpp}/include/utf8cpp")
        (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
      ];
      extraPatches = [
        ./utf8cpp.patch
        ./4.9.runtime.cpp.cmake.patch
      ];
    }).antlr;
}
