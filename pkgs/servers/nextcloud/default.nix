{ lib, stdenv, fetchurl, nixosTests }:

let
  generic = {
    version, hash,
    eol ? false, extraVulnerabilities ? []
  }: let
    major = lib.versions.major version;
    prerelease = builtins.length (lib.versions.splitVersion version) > 3;
  in stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/${if prerelease then "prereleases" else "release"}/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    patches = [ (./patches + "/v${major}/0001-Setup-remove-custom-dbuser-creation-behavior.patch") ];

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud23 = throw ''
    Nextcloud v23 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2022-12. Please upgrade to at least Nextcloud v24 by declaring

        services.nextcloud.package = pkgs.nextcloud24;

    in your NixOS config.

    WARNING: if you were on Nextcloud 22 on NixOS 22.05 you have to upgrade to Nextcloud 23
    first on 22.05 because Nextcloud doesn't support upgrades across multiple major versions!
  '';

  nextcloud24 = generic {
    version = "24.0.9";
    hash = "sha256-WAozhMnAmu+46bQVU9IabiAAF5lUnb0lsx3qIR2X3R4=";
  };

  nextcloud25 = generic {
    version = "25.0.3";
    hash = "sha256-SysUI3Nu+SRpCW/iT2HCTK2Ho04HwceoGzhdPqJcAOw=";
  };

  nextcloud26 = generic {
    version = "26.0.0beta1";
    hash = "sha256-EfSfn0KjQzciHa3VcrDhGC/aZUw/KDjihXs+qVIcYX0=";
  };

  # tip: get hash with:
  # nix hash to-sri --type sha256 $(curl https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256 | cut -d' ' -f1)
}
