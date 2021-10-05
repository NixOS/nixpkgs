{ lib, stdenv, fetchurl, jre
, fetchpatch, fetchFromGitHub, cmake, ninja, pkg-config, libuuid, utf8cpp, darwin }:

let
  version = "4.9.2";
  source = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = version;
    sha256 = "0rpqgl2y22iiyg42y8jyiy2g7x421yf0q16cf17j76iai6y0bm5p";
  };

  runtime = {
    cpp = stdenv.mkDerivation {
      pname = "antlr-runtime-cpp";
      inherit version;
      src = source;

      outputs = [ "out" "dev" "doc" ];

      patches = [
        (fetchpatch {
          name = "use-utfcpp-from-system.patch";
          url = "https://github.com/antlr/antlr4/commit/5a808b470e1314b63b0a921178040ccabb357945.patch";
          sha256 = "0nq7iajy9inllcspyqpxskfg3k5s1fwm7ph75i8lfc25rl35k1w7";
        })
      ];

      patchFlags = [ "-p3" ];

      nativeBuildInputs = [ cmake ninja pkg-config ];
      buildInputs = [ utf8cpp ]
        ++ lib.optional stdenv.isLinux libuuid
        ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreFoundation;

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
      sha256 = "1k9pw5gv2zhh06n1vys76kchlz4mz0vgv3iiba8w47b9fqa7n4dv";
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
      license = licenses.bsd3;
      platforms = platforms.unix;
    };
  };
in antlr
