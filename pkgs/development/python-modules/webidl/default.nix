{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webidl";
  version = "0-unstable-2025-06-15";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "verso-browser";
    repo = "verso";
    rev = "ace264e0e73da37bfb14818d92f0e54946ce9871";
    hash = "sha256-gjg7qs2ik1cJcE6OTGN4KdljqJDGokCo4JdR+KopMJw=";
  };

  sourceRoot = "${src.name}/third_party/WebIDL";

  build-system = [ setuptools ];

  dependencies = [ ply ];

  pythonImportsCheck = [
    "WebIDL"
  ];

  meta = {
    description = "WebIDL parser written in Python";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };

}
