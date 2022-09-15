{ lib, stdenv, fetchurl, jre
, fetchpatch, fetchFromGitHub, cmake, ninja, pkg-config, darwin }:

let
  version = "4.11.1";
  source = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = version;
    sha256 = "sha256-SUeDgfqLjYQorC8r/CKlwbYooTThMOILkizwQV8pocc=";
  };

  runtime = {
    cpp = stdenv.mkDerivation {
      pname = "antlr-runtime-cpp";
      inherit version;
      src = source;

      outputs = [ "out" "dev" "doc" ];

      patchFlags = [ "-p3" ];

      nativeBuildInputs = [ cmake ninja pkg-config ];
      buildInputs =
        lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreFoundation;

      cmakeFlags = [
        # Generate CMake config files, which are not installed by default.
        "-DANTLR4_INSTALL=on"

        # Disable tests, since they require downloading googletest, which is
        # not available in a sandboxed build.
        "-DANTLR_BUILD_CPP_TESTS=OFF"
      ];

      postUnpack = ''
        export sourceRoot=$sourceRoot/runtime/Cpp
      '';

      meta = with lib; {
        description = "C++ target for ANTLR 4";
        homepage = "https://www.antlr.org/";
        license = licenses.bsd3;
        platforms = platforms.unix;
      };
    };
  };

  antlr = stdenv.mkDerivation {
    pname = "antlr";
    inherit version;

    src = fetchurl {
      url = "https://www.antlr.org/download/antlr-${version}-complete.jar";
      sha256 = "sha256-YpdeGStK8mIrcrXwExVT7jy86X923CpBYy3MVeJUc+E=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out"/{share/java,bin}
      cp "$src" "$out/share/java/antlr-${version}-complete.jar"

      echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
      echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.Tool \"\$@\"" >> "$out/bin/antlr"

      echo "#! ${stdenv.shell}" >> "$out/bin/grun"
      echo "'${jre}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' org.antlr.v4.gui.TestRig \"\$@\"" >> "$out/bin/grun"

      chmod a+x "$out/bin/antlr" "$out/bin/grun"
      ln -s "$out/bin/antlr"{,4}
    '';

    inherit jre;

    passthru = {
      inherit runtime;
      jarLocation = "${antlr}/share/java/antlr-${version}-complete.jar";
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
      homepage = "https://www.antlr.org/";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  };
in antlr
