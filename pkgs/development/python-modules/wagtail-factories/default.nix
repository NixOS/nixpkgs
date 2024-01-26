{ buildPythonPackage
, callPackage
, factory-boy
, fetchFromGitHub
, lib
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-factories";
  version = "4.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-xNLHJ/8IZt3pzHAzr9swcL6GcIQyIjIFfoeHUW1i76U=";
  };

  propagatedBuildInputs = [
    factory-boy
    wagtail
  ];

  # Tests require wagtail which in turn requires wagtail-factories
  # Note that pythonImportsCheck is not used because it requires a Django app
  doCheck = false;

  passthru.tests.wagtail-factories = callPackage ./tests.nix { };

  meta = with lib; {
    description = "Factory boy classes for wagtail";
    homepage = "https://github.com/wagtail/wagtail-factories";
    changelog = "https://github.com/wagtail/wagtail-factories/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
