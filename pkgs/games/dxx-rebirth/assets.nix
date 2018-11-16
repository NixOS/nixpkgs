{ stdenv, requireFile, gogUnpackHook }:

let
  generic = ver: source: let
    pname = "descent${toString ver}";
  in stdenv.mkDerivation rec {
    name = "${pname}-assets-${version}";
    version = "2.0.0.7";

    src = requireFile rec {
      name = "setup_descent12_${version}.exe";
      sha256 = "1r1drbfda6czg21f9qqiiwgnkpszxgmcn5bafp5ljddh34swkn3f";
      message = ''
        While the Descent ${toString ver} game engine is free, the game assets are not.

        Please purchase the game on gog.com and download the Windows installer.

        Once you have downloaded the file, please use the following command and re-run the
        installation:

        nix-prefetch-url file://\$PWD/${name}
      '';
    };

    nativeBuildInputs = [ gogUnpackHook ];

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/{games/${pname},doc/${pname}/examples}
      pushd "app/${source}"
      mv dosbox*.conf $out/share/doc/${pname}/examples
      mv *.txt *.pdf  $out/share/doc/${pname}
      cp -r * $out/share/games/descent${toString ver}
      popd

      runHook postInstall
    '';

    meta = with stdenv.lib; {
      description = "Descent ${toString ver} assets from GOG";
      homepage    = https://www.dxx-rebirth.com/;
      license     = licenses.unfree;
      maintainers = with maintainers; [ peterhoeg ];
      hydraPlatforms = [];
    };
  };

in {
  descent1-assets = generic 1 "descent";
  descent2-assets = generic 2 "descent 2";
}
