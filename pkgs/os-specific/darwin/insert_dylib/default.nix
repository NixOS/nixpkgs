{ stdenv, fetchFromGitHub, xcbuildHook }:

stdenv.mkDerivation
  { name = "insert_dylib-2016.08.28";
    src = fetchFromGitHub
      { owner = "Tyilo";
        repo = "insert_dylib";
        rev = "c8beef66a08688c2feeee2c9b6eaf1061c2e67a9";
        sha256 = "0az38y06pvvy9jf2wnzdwp9mp98lj6nr0ldv0cs1df5p9x2qvbya";
      };
    nativeBuildInputs = [ xcbuildHook ];
    installPhase =
      ''
        mkdir -p $out/bin
        install -m755 Products/Release/insert_dylib $out/bin
      '';
    meta.platforms = stdenv.lib.platforms.darwin;
  }
