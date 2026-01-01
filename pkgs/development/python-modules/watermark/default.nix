{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  ipython,
  py3nvml,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "watermark";
<<<<<<< HEAD
  version = "2.5.1";
  pyproject = true;

=======
  version = "2.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "watermark";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vHnXPGHPQz6+y2ZvfmUouL/3JlATGo4fmZ8AIk+bNEU=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
    hash = "sha256-UR4kV6UoZ/JLO19on+qEH+M05QIsT0SXvXJtTMCKuZM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ipython
    importlib-metadata
  ];

  optional-dependencies = {
    gpu = [ py3nvml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "watermark" ];

  meta = {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    changelog = "https://github.com/rasbt/watermark/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nphilou ];
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "watermark" ];

  meta = with lib; {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    changelog = "https://github.com/rasbt/watermark/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
