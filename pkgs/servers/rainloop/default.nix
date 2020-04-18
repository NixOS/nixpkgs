{ stdenv, fetchurl, unzip, pkgs, dataPath ? "/var/lib/rainloop" }: let
  common = { edition, sha256 }:
    stdenv.mkDerivation (rec {
      pname = "rainloop${stdenv.lib.optionalString (edition != "") "-${edition}"}";
      version = "1.14.0";

      buildInputs = [ unzip ];

      unpackPhase = ''
        mkdir rainloop
        unzip -q -d rainloop $src
      '';

      src = fetchurl {
        url = "https://github.com/RainLoop/rainloop-webmail/releases/download/v${version}/rainloop-${edition}${stdenv.lib.optionalString (edition != "") "-"}${version}.zip";
        sha256 = sha256;
      };

      includeScript = pkgs.writeText "include.php" ''
        <?php

        /**
         * @return string
         */
        function __get_custom_data_full_path()
        {
          return '${dataPath}'; // custom data folder path
        }
      '';

      installPhase = ''
        mkdir $out
        cp -r rainloop/* $out
        rm -rf $out/data
        cp ${includeScript} $out/include.php
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
      sha256 = "0a8qafm4khwj8cnaiaxvjb9073w6fr63vk1b89nks4hmfv10jn6y";
    };
    rainloop-standard = common {
      edition = "";
      sha256 = "0961g4mci080f7y98zx9r4qw620l4z3na1ivvlyhhr1v4dywqvch";
    };
  }
