{ lib, stdenv, fetchurl, fetchFromGitHub, nim, gentium, SDL2, makeDesktopItem }:

let
  treeformLibs = lib.attrsets.mapAttrsToList (repo: args:
    fetchFromGitHub ({
      inherit repo;
      owner = "treeform";
    } // args)) {
      bumpy = {
        rev = "1.0.3";
        sha256 = "sha256-mDmDlhOGoYYjKgF5j808oT2NqRlfcOdLSDE3WtdJFQ0=";
      };
      chroma = {
        rev = "0.2.5";
        sha256 = "sha256-6lNHpO2aMorgkaPfo6kRcOs9r5R6T/kislVmkeoulw8=";
      };
      flatty = {
        rev = "0.2.1";
        sha256 = "sha256-TqNnRh2+i6n98ktLRVQxt9CVw17FGLNYq29rJoMus/0=";
      };
      pixie = {
        rev = "1.1.3";
        sha256 = "sha256-xKIejVxOd19mblL1ZwpJH91dgKQS5g8U08EL8lGGelA=";
      };
      typography = {
        rev = "0.7.9";
        sha256 = "sha256-IYjw3PCp5XzVed2fGGCt9Hb60cxFeF0BUZ7L5PedTLU=";
      };
      vmath = {
        rev = "1.0.3";
        sha256 = "sha256-zzSKXjuTZ46HTFUs0N47mxEKTKIdS3dwr+60sQYSdn0=";
      };
    };

  nimLibs = treeformLibs ++ [
    (fetchFromGitHub {
      owner = "nim-lang";
      repo = "sdl2";
      rev = "v2.0.2";
      sha256 = "sha256-Ivx/gxDa2HVDjCVrJVu23i4d0pDzzv+ThmwqNjtkjsA=";
    })
    (fetchFromGitHub {
      owner = "guzba";
      repo = "nimsimd";
      rev = "1.0.0";
      sha256 = "sha256-kp61fylAJ6MSN9hLYLi7CU2lxVR/lbrNCvZTe0LJLGo=";
    })
    (fetchFromGitHub {
      owner = "guzba";
      repo = "zippy";
      rev = "0.5.6";
      sha256 = "sha256-axp4t9+8TFSpvnATlRKZyuOGLA0e/XKfvrVSwreXpC4=";
    })
  ];

in stdenv.mkDerivation rec {
  pname = "hottext";
  version = "1.3";

  src = fetchurl {
    url = "https://git.sr.ht/~ehmry/hottext/archive/v${version}.tar.gz";
    sha256 = "sha256-iz7Z2x0/yi/E6gGFkYgq/yZDOxrZGwQmumPoO9kckLQ=";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ SDL2 ];

  nimFlags = [ "-d:release" ] ++ map (lib: "--path:${lib}/src") nimLibs;

  HOTTEXT_FONT_PATH = "${gentium}/share/fonts/truetype/GentiumPlus-Regular.ttf";

  buildPhase = ''
    runHook preBuild
    HOME=$TMPDIR
    nim $nimFlags compile src/$pname
    runHook postBuild
  '';

  desktopItem = makeDesktopItem {
    categories = "Utility;";
    comment = meta.description;
    desktopName = pname;
    exec = pname;
    name = pname;
  };

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin src/$pname
    cp -r $desktopItem/* $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple RSVP speed-reading utility";
    license = licenses.unlicense;
    homepage = "https://git.sr.ht/~ehmry/hottext";
    maintainers = with maintainers; [ ehmry ];
  };
}
