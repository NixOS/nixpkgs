{ lib, stdenv, fetchurl, jre
, fetchFromGitHub, cmake, ninja, pkg-config, libuuid, darwin }:

let
  version = "4.8";
  source = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = version;
    sha256 = "1qal3add26qxskm85nk7r758arladn5rcyjinmhlhznmpbbv9j8m";
  };

  runtime = {
    cpp = stdenv.mkDerivation {
      pname = "antlr-runtime-cpp";
      inherit version;
      src = source;

      outputs = [ "out" "dev" "doc" ];

      nativeBuildInputs = [ cmake ninja pkg-config ];
      buildInputs = lib.optional stdenv.isLinux libuuid
        ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreFoundation;

      # Install CMake config files, used to locate the runtime from another
      # CMake project, using the find_package function.
      cmakeFlags = [ "-DANTLR4_INSTALL=ON" ];

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
      url ="https://www.antlr.org/download/antlr-${version}-complete.jar";
      sha256 = "0nms976cnqyr1ndng3haxkmknpdq6xli4cpf4x4al0yr21l9v93k";
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
