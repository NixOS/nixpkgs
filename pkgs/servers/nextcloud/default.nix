{ lib, stdenvNoCC, fetchurl, nixosTests
, nextcloud27Packages
, nextcloud28Packages
, nextcloud29Packages
}:

let
  generic = {
    version, hash
  , eol ? false, extraVulnerabilities ? []
  , packages
  }: stdenvNoCC.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    passthru = {
      tests = nixosTests.nextcloud;
      inherit packages;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin ma27 ];
      license = licenses.agpl3Plus;
      platforms = platforms.linux;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud27 = generic {
    version = "27.1.10";
    hash = "sha256-lD4ScNdxp8gNqisy5ylM6MO3e56u9yrYs4SH1YyFB1Y=";
    packages = nextcloud27Packages;
  };

  nextcloud28 = generic {
    version = "28.0.6";
    hash = "sha256-3w0zhLRHy6HhKPIggPZ4BSH4aBab6r7o6g0VW/nGa48=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.2";
    hash = "sha256-LUnSl9w0AJICEFeCPo54oxK8APVt59hneseQWQkYqxc=";
    packages = nextcloud29Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
