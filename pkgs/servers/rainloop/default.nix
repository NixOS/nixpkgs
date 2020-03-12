{ stdenv, fetchurl, unzip, dataPath ? "/etc/rainloop" }: let
  common = { edition, sha256 }:
    stdenv.mkDerivation (rec {
      pname = "rainloop${stdenv.lib.optionalString (edition != "") "-${edition}"}";
      version = "1.13.0";

      buildInputs = [ unzip ];

      unpackPhase = ''
        mkdir rainloop
        unzip -q -d rainloop $src
      '';

      src = fetchurl {
        url = "https://github.com/RainLoop/rainloop-webmail/releases/download/v${version}/rainloop-${edition}${stdenv.lib.optionalString (edition != "") "-"}${version}.zip";
        sha256 = sha256;
      };

      installPhase = ''
        mkdir $out
        cp -r rainloop/* $out
        rm -rf $out/data
        ln -s ${dataPath} $out/data
      '';

      meta = with stdenv.lib; {
        description = "Simple, modern & fast web-based email client";
        homepage = "https://www.rainloop.net";
        downloadPage = "https://github.com/RainLoop/rainloop-webmail/releases";
        license = with licenses; if edition == "" then unfree else agpl3;
        platforms = platforms.all;
        maintainers = with maintainers; [ das_j ];
      };
    });
  in {
    rainloop-community = common {
      edition = "community";
      sha256 = "1skwq6bn98142xf8r77b818fy00nb4x0s1ii3mw5849ih94spx40";
    };
    rainloop-standard = common {
      edition = "";
      sha256 = "e3ec8209cb3b9f092938a89094e645ef27659763432bedbe7fad4fa650554222";
    };
  }
