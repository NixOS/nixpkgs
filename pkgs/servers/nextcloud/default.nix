{ stdenv, fetchurl, nixosTests }:

let
  generic = { version, sha256, insecure ? false }: stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      mkdir -p $out/
      cp -R . $out/
    '';

    meta = with stdenv.lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin fpletz ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = optional insecure "Nextcloud version ${version} is EOL";
    };
  };
in {
  nextcloud17 = throw ''
    Nextcloud v17 has been removed from `nixpkgs` as the support for it will be dropped
    by upstream within the lifetime of NixOS 20.09[1]. Please upgrade to Nextcloud v18 by
    declaring

        services.nextcloud.package = pkgs.nextcloud18;

    in your NixOS config.

    [1] https://docs.nextcloud.com/server/18/admin_manual/release_schedule.html
  '';

  nextcloud18 = generic {
    version = "18.0.9";
    sha256 = "0rigg5pv2vnxgmjznlvxfc41s00raxa8jhib5vsznhj55qn99jm1";
    insecure = true;
  };

  nextcloud19 = generic {
    version = "19.0.3";
    sha256 = "0sc9cnsdh8kj60h7i3knh40ngdz1w1wmdqw2v2axfkmax22kjl7w";
  };

  nextcloud20 = generic {
    version = "20.0.1";
    sha256 = "1z1fzz1i41k4dhdhi005l3gzkvnmmgqqz3rdr374cvk73q7bbiln";
  };
}
