{ buildPythonPackage
, callPackage
, factory_boy
, fetchFromGitHub
, lib
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-factories";
  version = "4.0.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
    rev = version;
    sha256 = "sha256-JmFWf+TODQNsSSxYD/JYVhWc82o6rJL13j5J23r8J9A=";
  };

  propagatedBuildInputs = [
    factory_boy
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
