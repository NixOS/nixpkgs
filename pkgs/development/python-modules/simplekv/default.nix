{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,

  # optional dependencies
  azure-storage-blob,
  boto3,
  dulwich,
  google-cloud-storage,
  pymongo,
  redis,

  # testing
  mock,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "simplekv";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "simplekv";
    tag = version;
    hash = "sha256-seUGDj2q84+AjDFM1pxMLlHbe9uBgEhmqA96UHjnCmo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    six
  ]
  ++ optional-dependencies.git;

  pythonImportsCheck = [ "simplekv" ];

  disabledTests = [
    # Issue with fixture
    "test_concurrent_mkdir"
  ];

  optional-dependencies = {
    amazon = [ boto3 ];
    azure = [ azure-storage-blob ];
    google = [ google-cloud-storage ];
    redis = [ redis ];
    mongodb = [ pymongo ];
    git = [ dulwich ];
    /*
      Additional potential dependencies not exposed here:
        sqlalchemy: Our version is too new for simplekv
        appengine-python-standard: Not packaged in nixpkgs
    */
  };

  meta = with lib; {
    description = "Simple key-value store for binary data";
    homepage = "https://github.com/mbr/simplekv";
    changelog = "https://github.com/mbr/simplekv/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      bbenne10
    ];
  };
}
