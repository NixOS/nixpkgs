{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  simplejson,
  six,
  typechecks,
}:

buildPythonPackage rec {
  pname = "serializable";
  version = "unstable-2023-07-13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iskandr";
    repo = pname;
    # See https://github.com/iskandr/serializable/issues/7. As of 2023-07-13,
    # they do no have version tags.
    rev = "ed309a6f8f2590b525fc0f93c00549223c8c944f";
    hash = "sha256-AXlgIc1B7bkR+joXn6ZSxk/t848CWlgVZp8WIsSZFKQ=";
  };

  propagatedBuildInputs = [
    simplejson
    six
    typechecks
  ];

  pythonImportsCheck = [ "serializable" ];

  meta = with lib; {
    description = "Base class with serialization methods for user-defined Python objects";
    homepage = "https://github.com/iskandr/serializable";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
