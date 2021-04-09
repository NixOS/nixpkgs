{ stdenv, fetchurl, nixosTests }:

let
  generic = {
    version, sha256,
    eol ? false, extraVulnerabilities ? []
  }: stdenv.mkDerivation rec {
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
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
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
    eol = true;
  };

  nextcloud19 = generic {
    version = "19.0.6";
    sha256 = "sha256-pqqIayE0OyTailtd2zeYi+G1APjv/YHqyO8jCpq7KJg=";
    extraVulnerabilities = [
      "Nextcloud 19 is still supported, but CVE-2020-8259 & CVE-2020-8152 are unfixed! Please note that both CVEs only affect the file encryption module which is turned off by default. Alternatively, `pkgs.nextcloud20` can be used."
    ];
  };

  nextcloud20 = generic {
    version = "20.0.7";
    sha256 = "sha256-jO2Ct3K/CvZ9W+EyPkD5d0KbwKK8yGQJXvx4dnUAtys=";
  };

  nextcloud21 = generic {
    version = "21.0.1";
    sha256 = "dd7c8ccc01547914a75b44bbf86028289c8919dc39f4e2e720147b6bd596aebe";
  };
  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
