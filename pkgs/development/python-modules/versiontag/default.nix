{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  git,
}:

buildPythonPackage (finalAttrs: {
  pname = "versiontag";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thelabnyc";
    repo = "python-versiontag";
    rev = "r${finalAttrs.version}";
    hash = "sha256-FiT6jblJKGlmnJmU1c7ZKbviv9ggbKmaKvtNT4IQu6s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "get_version(pypi=True)" '"${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ git ];

  pythonImportsCheck = [ "versiontag" ];

  meta = {
    description = "Python library designed to make accessing the current version number of your software easy";
    homepage = "https://github.com/thelabnyc/python-versiontag";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ MaskedBelgian ];
  };
})
