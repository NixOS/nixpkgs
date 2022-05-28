{ lib
, callPackage
, fetchFromGitHub
, python310
}:

let
  py = python310.override {
    packageOverrides = self: super: {
      # Incompatible with aioredis 2
      aioredis = super.aioredis.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0fi7jd5hlx8cnv1m97kv9hc4ih4l8v15wzkqwsp73is4n0qazy0m";
        };
      });
    };
  };
in

py.pkgs.buildPythonPackage rec {
  pname = "authentik";
  version = "2022.5.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    sha256 = "sha256-tdsWybTpDmAC2tJ2hmYCJ0auHsLpfZZ5lVoGeuGGfGg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "psycopg2-binary" "psycopg2"

    substituteInPlace lifecycle/ak \
      --replace "python -m manage" "${placeholder "out"}/bin/manage.py"
    patchShebangs lifecycle/ak
  '';

  nativeBuildInputs = with py.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with py.pkgs; [
    celery
    channels
    channels-redis
    codespell
    colorama
    dacite
    deepmerge
    defusedxml
    django
    django-filter
    django-guardian
    django-model-utils
    django-otp
    django-prometheus
    django-redis
    djangorestframework
    djangorestframework-guardian
    docker
    drf-spectacular
    duo-client
    facebook-sdk
    flower
    geoip2
    gunicorn
    kubernetes
    ldap3
    lxml
    packaging
    paramiko
    psycopg2
    pycryptodome
    pyjwt
    pyyaml
    requests-oauthlib
    sentry-sdk
    service-identity
    structlog
    swagger-spec-validator
    twisted
    ua-parser
    urllib3
    uvicorn
    webauthn
    wsproto
    xmlsec
  ] /*++ urllib3.optional-dependencies.secure*/; # FIXME

  postInstall = ''
    cp -r lifecycle $out/${py.sitePackages}
    cp manage.py $out/bin/
  '';

  pythonImportsCheck = [ "authentik" ];

  passthru.proxy = callPackage ./proxy.nix { };

  meta = with lib; {
    description = "The authentication glue you need";
    homepage = "https://github.com/goauthentik/authentik";
    license = licenses.gpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
