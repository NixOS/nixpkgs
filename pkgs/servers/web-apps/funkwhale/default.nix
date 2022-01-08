{ lib
, callPackage
, fetchFromGitLab
, fetchFromGitHub
, python3
, mkYarnPackage
, fetchYarnDeps
, jq
, ffmpeg
, nixosTests
}:

let
  pinData = lib.importJSON ./pin.json;

  pname = "funkwhale";
  version = pinData.version;

  python = python3.override {
    packageOverrides = self: super: {
      aioredis = super.aioredis.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fi7jd5hlx8cnv1m97kv9hc4ih4l8v15wzkqwsp73is4n0qazy0m";
        };
      });

      # https://dev.funkwhale.audio/funkwhale/funkwhale/-/issues/1516
      asgiref = super.asgiref.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.4";
        src = fetchFromGitHub {
          owner = "django";
          repo = "asgiref";
          rev = version;
          sha256 = "1rr76252l6p12yxc0q4k9wigg1jz8nsqga9c0nixy9q77zhvh9n2";
        };
      });

      django = super.django_3;

      django-oauth-toolkit = super.django-oauth-toolkit.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = fetchFromGitHub {
          owner = "jazzband";
          repo = "django-oauth-toolkit";
          rev = version;
          sha256 = "1il6g4vqxh9s8sh3b3vqw7l6y504nl15c0lbh0jin59ns9y61hg3";
        };
      });
    };
  };

  src = fetchFromGitLab {
    domain = "dev.funkwhale.audio";
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = pinData.repoSha256;
  };

  frontend = mkYarnPackage {
    pname = "funkwhale-frontend";
    inherit version;
    src = src + "/front";
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      name = "funkwhale-frontend-yarndeps-${version}";
      yarnLock = src + "/front/yarn.lock";
      sha256 = pinData.yarnOfflineCacheSha256;
    };

    postPatch = ''
      # patch shebangs that patchshebangs can't handle
      sed -i 's/env -S bash -eux/env bash\nset -eu/' scripts/*.sh

      # get rid of yarns offline warnings
      substituteInPlace scripts/utils.sh \
        --replace "yarn bin" "yarn --offline bin"

      # follow symlinks in find command
      substituteInPlace scripts/fix-fomantic-css.sh \
        --replace "find" "find -L"

      patchShebangs scripts
    '';

    nativeBuildInputs = [
      jq
      python3
    ];

    buildPhase = ''
      export HOME=$PWD/yarn_home
      (
        cd deps/front
        rm node_modules
        ln -s ../../node_modules node_modules
      )
      yarn --offline run fix-fomantic-css

      # Error: No PostCSS Config found in: /build/front/node_modules/fomantic-ui-css/tweaked
      echo "module.exports = {};" > node_modules/fomantic-ui-css/tweaked/postcss.config.js

      yarn --offline build
    '';

    installPhase = ''
      cp -rv deps/front/dist $out
    '';

    distPhase = "true";
  };

  path = lib.makeBinPath [
    ffmpeg
  ];
in
python.pkgs.buildPythonApplication rec {
  inherit pname version src;
  format = "other";

  dontBuild = true;

  propagatedBuildInputs = with python.pkgs; [
    PyLD
    aiohttp
    arrow
    asgiref
    bleach
    boto3
    celery
    cffi
    channels
    channels-redis
    click
    cryptography
    django-allauth
    django-auth-ldap
    django-cacheops
    django-cleanup
    django-cors-headers
    django-dynamic-preferences
    django-environ
    django-filter
    django-oauth-toolkit
    django-redis
    django-rest-auth
    django-storages
    django-versatileimagefield
    django
    djangorestframework
    feedparser
    kombu
    ldap
    markdown
    musicbrainzngs
    mutagen
    persisting-theory
    pillow
    psycopg2
    pydub
    pymemoize
    pyopenssl
    magic
    pytz
    redis
    requests
    requests-http-signature
    service-identity
    unicode-slugify
    uvicorn
    watchdog
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp -r $src/api $out/lib/funkwhale

    chmod +x $out/lib/funkwhale/manage.py
    makeWrapper $out/lib/funkwhale/manage.py $out/bin/funkwhale \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PATH : "${path}"
  '';

  # tests require postgresl, due to usage of pg_extensions
  doCheck = false;

  passthru = {
    inherit frontend path python;
    pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) funkwhale; };
  };

  meta = with lib; {
    description = "A social platform to enjoy and share music";
    homepage = "https://funkwhale.audio";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
