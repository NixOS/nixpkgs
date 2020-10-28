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
    version = "18.0.10";
    sha256 = "0kv9mdn36shr98kh27969b8xs7pgczbyjklrfskxy9mph7bbzir6";
    insecure = true;
  };

  nextcloud19 = generic {
    version = "19.0.4";
    sha256 = "0y5fccn61qf9fxjjpqdvhmxr9w5n4dgl1d7wcl2dzjv4bmqi2ms6";
  };

  nextcloud20 = generic {
    version = "20.0.1";
    sha256 = "1z1fzz1i41k4dhdhi005l3gzkvnmmgqqz3rdr374cvk73q7bbiln";
  };
}
