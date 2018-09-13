{stdenv, fetchurl, pkgs, ...}:
    stdenv.mkDerivation rec {
        version = "v2018.07.21-1";
        name = "sickrage-${version}";
        src = fetchurl {
            url = "https://github.com/SickRage/SickRage/archive/${version}.tar.gz";
            sha256 = "0dc9502853e0f004a9643bbe81527d3a9cfc6a6aa92a87e49d43fa10d21e89e5";
        };
        buildInputs = with pkgs; [python27];
        installPhase = ''
            mkdir $out
            cp -R * $out
        '';
        meta = {
            description = "Automatic Video Library Manager for TV Shows";
            longDescription = "It watches for new episodes of your favorite shows, and when they are posted it does its magic.";
            homepage = "https://sickrage.github.io/";
            license = stdenv.lib.licenses.gpl3;
            maintainers = ["sterfield@gmail.com"];
        };
    }
