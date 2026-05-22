{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  aiohttp,
  aiosmtplib,
  parse-crontab,
  jinja2,
  pytz,
  ruamel-yaml,
  sentry-sdk,
  strictyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "yacron";
  version = "0.19.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gjcarneiro";
    repo = "yacron";
    tag = finalAttrs.version;
    hash = "sha256-y9yr4EFzlB7dhLtT+LzQfXPOpKcsl+dQ+TUirkny4Tw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-quiet '"setuptools_scm", "pytest-runner"' '"setuptools_scm"'
  '';

  pythonRelaxDeps = [
    "crontab"
    "ruamel.yaml"
  ];

  pythonRemoveDeps = [
    "pytest-runner"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    aiosmtplib
    parse-crontab
    jinja2
    pytz
    ruamel-yaml
    sentry-sdk
    strictyaml
  ];

  doCheck = false; # Tests require complex asyncio loop mocks and time manipulation mocked out

  pythonImportsCheck = [ "yacron" ];

  meta = {
    description = "Cron replacement for Docker containers";
    longDescription = ''
      Yacron is a modern cron replacement that is designed to be run
      inside Docker containers. It handles emails, timeouts, and metrics.
    '';
    homepage = "https://github.com/gjcarneiro/yacron";
    changelog = "https://github.com/gjcarneiro/yacron/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
