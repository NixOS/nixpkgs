{ lib
, stdenv
, fetchFromGitHub
, git
, pkg-config
, python3
, zlib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "conan";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = "refs/tags/${version}";
    hash = "sha256-yx/MO5QAVKnGraQXJitXxaZooLtBqa+L04s73DwiE14=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    bottle
    colorama
    python-dateutil
    distro
    fasteners
    jinja2
    patch-ng
    pluginbase
    pygments
    pyjwt
    pylint # Not in `requirements.txt` but used in hooks, see https://github.com/conan-io/conan/pull/6152
    pyyaml
    requests
    tqdm
    urllib3
  ] ++ lib.optionals stdenv.isDarwin [
    idna
    cryptography
    pyopenssl
  ];

  nativeCheckInputs = [
    git
    pkg-config
    zlib
  ] ++ (with python3.pkgs; [
    mock
    parameterized
    pytest-xdist
    pytestCheckHook
    webtest
  ]);

  pythonImportsCheck = [
    "conan"
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
  ];

  disabledTests = [
    # Tests require network access
    "TestFTP"
  ];

  disabledTestPaths = [
    # Requires cmake, meson, autotools, apt-get, etc.
    "conans/test/functional/command/new_test.py"
    "conans/test/functional/command/test_install_deploy.py"
    "conans/test/functional/layout/test_editable_cmake.py"
    "conans/test/functional/layout/test_in_subfolder.py"
    "conans/test/functional/layout/test_source_folder.py"
    "conans/test/functional/toolchains/"
    "conans/test/functional/tools_versions_test.py"
    "conans/test/functional/tools/system/package_manager_test.py"
    "conans/test/functional/util/test_cmd_args_to_string.py"
    "conans/test/unittests/tools/env/test_env_files.py"
  ];

  meta = with lib; {
    description = "Decentralized and portable C/C++ package manager";
    homepage = "https://conan.io";
    changelog = "https://github.com/conan-io/conan/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
