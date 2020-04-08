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
    version = "17.0.4";
    sha256 = "0cj5mng0nmj3hz30pyz3g19kj3mkm5ca8si3sw3arv61dmw6c5g6";
  };

  nextcloud18 = generic {
    version = "18.0.3";
    sha256 = "0wpxa35zj81i541j3cjq6klsjwwc5slryzvjjl7zjc32004yfrvv";
  };
}
