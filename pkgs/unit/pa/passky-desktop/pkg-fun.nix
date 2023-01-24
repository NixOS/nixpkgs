{ lib, stdenv, fetchurl, appimageTools, undmg }:

let
  pname = "passky-desktop";
  version = "7.1.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Rabbit-Company/Passky-Desktop/releases/download/v${version}/Passky-${version}.AppImage";
      sha256 = "1xnhrmmm018mmyzjq05mhbf673f0n81fh1k3kbfarbgk2kbwpq6y";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/Rabbit-Company/Passky-Desktop/releases/download/v${version}/Passky-${version}.dmg";
      sha256 = "0mm7hk4v7zvpjdqyw3nhk33x72j0gh3f59bx3q18azlm4dr61r2d";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  appimageContents = appimageTools.extract { inherit pname version src; };
  meta = with lib; {
    homepage = "https://passky.org";
    downloadPage = "https://github.com/Rabbit-Company/Passky-Desktop/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akkesm ];
    platforms = builtins.attrNames srcs;
  };

  linux = appimageTools.wrapType2 {
    inherit pname version src meta;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -D ${appimageContents}/passky.desktop \
        $out/share/applications/${pname}.desktop

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };
in
if stdenv.isDarwin
  then darwin
  else linux
