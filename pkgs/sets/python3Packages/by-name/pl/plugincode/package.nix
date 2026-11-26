{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  click,
  commoncode,
  pluggy,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "plugincode";
  version = "32.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QTLZOxdVJxxuImydouIET/YuvLhztelY1mqN3enzRfo=";
  };

  dontConfigure = true;

  # pluggy 1.7 rejects the class-based hookspecs, which nothing ever calls: https://github.com/aboutcode-org/plugincode/issues/14
  postPatch = ''
    substituteInPlace src/plugincode/__init__.py \
      --replace-fail "self.manager.add_hookspecs(sys.modules[module_qname])" ""
    substituteInPlace src/plugincode/location_provider.py \
      --replace-fail "self.manager.add_hookspecs(sys.modules[project_name])" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click
    commoncode
    pluggy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  # wants to read /etc/os-release and crashes because that is not available in the sandbox
  # pythonImportsCheck = [ "plugincode" ];

  disabledTests = [
    # We don't want black as an input
    "test_skeleton_codestyle"
  ];

  meta = {
    description = "Library that provides plugin functionality for ScanCode toolkit";
    homepage = "https://github.com/nexB/plugincode";
    changelog = "https://github.com/nexB/plugincode/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
