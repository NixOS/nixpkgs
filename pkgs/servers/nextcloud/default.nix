{ lib, stdenvNoCC, zopfli, brotli, fetchurl, nixosTests
, xorg
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

    outputs = [ "out" "compressed" ];

    nativeBuildInputs = [ xorg.lndir zopfli brotli ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/

      # Create missing static gzip and brotli files
      mkdir $compressed
      lndir $out/ $compressed/
      shopt -s globstar
      for f in apps/** core/** dist/** resources/** themes/**; do
        if [ -f "$f" ]; then
          case "$f" in
          *.css | *.js | *.json | *.svg | *.ico | *.txt | *.md | *.xml | *.html | *.ttf | *.otf | *.eot)
            mkdir -p "$compressed/''${f%/*}"
            zopfli --gzip -c "$f" > "$compressed/$f.gz"
            brotli --best --keep --output="$compressed/$f.br" "$f"
            ;;
          esac
        fi
      done

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
  nextcloud28 = generic {
    version = "28.0.8";
    hash = "sha256-VaL3RfzI8BtYFrIzM/HjAU0gQKZnlOEy3dDSGaN75To=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.4";
    hash = "sha256-GcRp4mSzHugEAPg5ZGCFRUZWnojbTBX8CFThkvlgJ+s=";
    packages = nextcloud29Packages;
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
