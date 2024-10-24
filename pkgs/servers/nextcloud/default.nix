{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
  nextcloud28Packages,
  nextcloud29Packages,
  nextcloud30Packages,
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
        ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    };
in
{
  nextcloud28 = generic {
    version = "28.0.11";
    hash = "sha256-S6rs7GpvFFgy28PGNdcuIM1IBKytmmZOanS5CnmB40g=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.8";
    hash = "sha256-CrVLUX92zSbyvTi2/hhLn7rtMvc0JGxYwaz4NHPApLk=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.1";
    hash = "sha256-eewv+tYjG9j8xKuqzBLlrFHmcNCJr/s3lINZLNoP3Ms=";
    packages = nextcloud30Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
