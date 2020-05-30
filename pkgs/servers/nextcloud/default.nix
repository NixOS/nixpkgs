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
  nextcloud17 = generic {
    version = "17.0.6";
    sha256 = "0qq7lkgzsn1zakfym5bjqzpcisxmgfcdd927ddqlhddy3zvgxrxx";
  };

  nextcloud18 = generic {
    version = "18.0.4";
    sha256 = "0aa3f4xbkzacfw0h9aic0ywk5mqlwka83qaszizj8lmk68kf3n7s";
  };
}
