{ lib, buildGoModule, fetchFromGitHub, buildNpmPackage, nixosTests, symlinkJoin }:

let
  autobrrGoModule = buildGoModule rec {
      pname = "autobrr";
      version = "1.26.2";

      src = fetchFromGitHub {
        owner = "autobrr";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-gaghZg01w29WGq1hzRUTGgXLemiMJqTD11kDh89ZxcQ=";
      };
      vendorSha256 = "sha256-AbPGxY7XkqsCGx21aBPpPWbp+uuuzAIMYA6oiORr0jM=";
      # nativeBuildInputs = [ pkg-config ];
      doCheck = false;
      meta = with lib; {
        description = "Modern, easy to use download automation for torrents and usenet.";
        license = licenses.gpl2;
        homepage = "https://autobrr.com/";
        maintainers = with maintainers; [ borgstad ];
      };
    };

  autobrrWeb = buildNpmPackage rec {
      pname = "autobrr";
      version = "1.26.2";
      src = fetchFromGitHub {
        owner = "autobrr";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-gaghZg01w29WGq1hzRUTGgXLemiMJqTD11kDh89ZxcQ=";
      };
      npmDepsHash = "sha256-Xw3uYKmAtDMBx5+gwEcM09nSJN9zhl1g113Szf+W54c=";
      npmFlags = [ "--legacy-peer-deps" ];
      prePatch = ''
        ls | grep -xv "web" | xargs rm -rf
        mv web/* .
        rm -rf web
        cp ${./package-lock.json} ./package-lock.json
      '';
      installPhase = ''
        runHook preInstall

        mkdir -p $out/autobrr-web
        cp  -a dist/* $out/autobrr-web

        runHook postInstall
      '';
    };

in
symlinkJoin {
  name = "autobrr";

  passthru = {
    inherit autobrrWeb autobrrGoModule;
  };

  paths = [
    autobrrWeb
    autobrrGoModule
  ];
}
