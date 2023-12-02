{ lib
, fetchFromGitHub
, fetchNpmDeps
, fetchPypi
, nodejs
, npmHooks
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      mistune = super.mistune.overridePythonAttrs (old: rec {
        version = "2.0.5";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "lektor";
  version = "3.4.0b8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FtmRW4AS11zAX2jvGY8XTsPrN3mhHkIWoFY7sXmqG/U=";
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/frontend";
    hash = "sha256-Z7LP9rrVSzKoLITUarsnRbrhIw7W7TZSZUgV/OT+m0M=";
  };

  npmRoot = "frontend";

  nativeBuildInputs = [
    python.pkgs.hatch-vcs
    python.pkgs.hatchling
    nodejs
    npmHooks.npmConfigHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    babel
    click
    exifread
    filetype
    flask
    inifile
    jinja2
    markupsafe
    marshmallow
    marshmallow-dataclass
    mistune
    pillow
    pip
    python-slugify
    requests
    watchfiles
    werkzeug
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest-click
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    cp -r lektor/translations "$out/${python.sitePackages}/lektor/"
  '';

  pythonImportsCheck = [
    "lektor"
  ];

  disabledTests = [
    # Tests require network access
    "test_path_installed_plugin_is_none"
    "test_VirtualEnv_run_pip_install"
    # expects FHS paths
    "test_VirtualEnv_executable"
  ];

  meta = with lib; {
    description = "A static content management system";
    homepage = "https://www.getlektor.com/";
    changelog = "https://github.com/lektor/lektor/blob/v${version}/CHANGES.md";
    license = licenses.bsd0;
    mainProgram = "lektor";
    maintainers = with maintainers; [ ];
  };
}
