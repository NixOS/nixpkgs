{ lib, python3, fetchFromGitHub, fetchurl }:
let
  python = python3.override {
    # override resolvelib due to
    # 1. pdm requiring a later version of resolvelib
    # 2. Ansible being packaged as a library
    # 3. Ansible being unable to upgrade to a later version of resolvelib
    # see here for more details: https://github.com/NixOS/nixpkgs/pull/155380/files#r786255738
    packageOverrides = self: super: {
      resolvelib = super.resolvelib.overridePythonAttrs (attrs: rec {
        version = "0.8.1";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = version;
          sha256 = "sha256-QDHEdVET7HN2ZCKxNUMofabR+rxJy0erWhNQn94D7eI=";
        };
      });
    };
    self = python;
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "1.12.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MXKER2ijU+2yPnsBFH0cu/hjHI4uNt++AqggH5rhnaU=";
  };

  # this patch allows us to run additional tests that invoke pdm, which checks
  # itself for an update on every invocation by default, drammatically slowing
  # down test runs inside the sandbox
  #
  # the patch is necessary because the fixture is creating a project and
  # doesn't appear to respect the settings in `$HOME`; possibly a bug upstream
  patches = [
    ./check-update.patch
    (fetchurl {
      # Mark test that require network access
      url = "https://github.com/pdm-project/pdm/files/7911962/mark-network-tests.patch.txt";
      hash = "sha256:1dizf9j3z7zk4lxvnszwx63xzd9r68f2iva5sszzf8s8na831dvd";
    })
  ];
  postPatch = ''
    substituteInPlace pyproject.toml --replace "pdm-pep517>=0.9,<0.10" "pdm-pep517"
  '';

  propagatedBuildInputs = [
    blinker
    click
    installer
    packaging
    pdm-pep517
    pep517
    pip
    platformdirs
    python-dotenv
    pythonfinder
    resolvelib
    shellingham
    tomli
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  pytestFlagsArray = [
    "--numprocesses $NIX_BUILD_CORES"
    "-m 'not network'"
  ];

  preCheck = "HOME=$TMPDIR";

  disabledTests = [
    # sys.executable and expected executable are different
    "test_set_non_exist_python_path"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_auto_isolate_site_packages"
    "test_use_invalid_wrapper_python"
    "test_use_wrapper_python"
    # tries to read/write files without proper permissions
    "test_completion_command"
    "test_plugin_add"
    "test_plugin_list"
    "test_plugin_remove"
    # tries to treat a gzip file as a zipfile and fails
    "test_resolve_local_artifacts"
  ];

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
