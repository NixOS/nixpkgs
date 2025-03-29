{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud29Packages,
  nextcloud30Packages,
  nextcloud31Packages,
}:

let
  generic =
    {
      version,
      hash,
      eol ? false,
      extraVulnerabilities ? [ ],
      packages,
    }:
    stdenvNoCC.mkDerivation rec {
      pname = "nextcloud";
      inherit version;

      src = fetchurl {
        url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
        inherit hash;
      };

      passthru = {
        tests = lib.filterAttrs (
          key: _: (lib.hasSuffix (lib.versions.major version) key)
        ) nixosTests.nextcloud;
        inherit packages;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/
        cp -R . $out/
        runHook postInstall
      '';

      meta = {
        changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
        description = "Sharing solution for files, calendars, contacts and more";
        homepage = "https://nextcloud.com";
        maintainers = with lib.maintainers; [
          schneefux
          bachp
          globin
          ma27
          britter
        ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    };
in
{
  nextcloud29 = generic {
    version = "29.0.14";
    hash = "sha256-mjMuAywSnD6Sp6EBkktfJnsJNvaJdJxF0DE0PIikavs=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.8";
    hash = "sha256-uwhqES+zUW50SSHXrhSCzBvVN+39HxQFHBNI1LatWKI=";
    packages = nextcloud30Packages;
  };

  nextcloud31 = generic {
    version = "31.0.2";
    hash = "sha256-ALVyERt8K5iELZXARt5570Y8z63IoEtUAGx4bh+UwxA=";
    packages = nextcloud31Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
