{ lib
, python3
, fetchFromGitHub
, honcho
, staticjinja
, redis
, nodejs
, mariadb
, postgresql
, yarn
, cron
, nginx
, gitMinimal
, coreutils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bench";
  version = "5.16.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frappe";
    repo = "bench";
    rev = "v${version}";
    hash = "sha256-r9H9IO+MvDu5Dgidqz8mHXjoDt5cU6Tw9UzMclHpSPI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'Jinja2~=3.0.3' 'Jinja2' \
      --replace 'python-crontab~=2.6.0' 'python-crontab' \
      --replace 'semantic-version~=2.8.2' 'semantic-version'
  '';

  propagatedBuildInputs = [
    coreutils
    gitMinimal
    # non-python runtime deps
    redis
    nodejs
    mariadb
    postgresql
    yarn
    cron
    # wkhtmltopdf - has unmaintained dep; pdf printing not available out of the box
    # https://github.com/frappe/bench/issues/1427
    nginx
  ] ++ (with python3.pkgs; [
    # for bench's own environment management
    pip
    supervisor
    psutil
    # other
    click
    gitpython
    python-crontab
    requests
    semantic-version
    setuptools
    tomli
    # python; but not in pythonPackages
    honcho
    staticjinja
  ]);

  nativeBuildInputs = with python3.pkgs; [
    hatchling
  ];

  pythonImportsCheck = [ "bench" ];

  meta = with lib; {
    description = "CLI to manage Multi-tenant deployments for Frappe apps";
    homepage = "https://github.com/frappe/bench";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ blaggacao ];
  };
}
