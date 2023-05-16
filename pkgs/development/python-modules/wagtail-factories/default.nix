{ buildPythonPackage
, callPackage
, factory_boy
, fetchFromGitHub
, lib
, wagtail
}:

buildPythonPackage rec {
  pname = "wagtail-factories";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "4.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = pname;
    owner = "wagtail";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    sha256 = "sha256-xNLHJ/8IZt3pzHAzr9swcL6GcIQyIjIFfoeHUW1i76U=";
=======
    rev = version;
    sha256 = "sha256-JmFWf+TODQNsSSxYD/JYVhWc82o6rJL13j5J23r8J9A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
