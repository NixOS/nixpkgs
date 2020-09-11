{ stdenv, fetchurl }:

let
  generic = { version, sha256, insecure ? false }: stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    installPhase = ''
      mkdir -p $out/
      cp -R . $out/
    '';

    meta = with stdenv.lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = https://nextcloud.com;
      maintainers = with maintainers; [ schneefux bachp globin fpletz ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = optional insecure "Nextcloud version ${version} is EOL";
    };
  };
in {
  nextcloud17 = generic {
    version = "17.0.9";
    sha256 = "0ky819ifc3apci6bjw0cgiza6an33c5lnm1slqazlqhylb8gh13v";
  };

  nextcloud18 = generic {
    version = "18.0.7";
    sha256 = "0pka87ccrds17n6n5w5a80mc1s5yrf8d4mf6wsfaypwjbm3wfb2b";
  };

  nextcloud19 = generic {
    version = "19.0.1";
    sha256 = "0bavwvjjgx62i150wqh4gqavjva3mnhx6k3im79ib6ck1ph13wsf";
  };
}
