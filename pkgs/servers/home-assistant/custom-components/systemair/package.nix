{
  lib,
  pymodbus,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  async-timeout,
  aiohttp,
}:

buildHomeAssistantComponent rec {
  owner = "AN3Orik";
  domain = "systemair";
<<<<<<< HEAD
  version = "1.0.18";
=======
  version = "1.0.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    inherit owner;
    repo = "systemair";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fhzL+pez92T77ZJ2aE/0ugGd9Dlg2uGa417pJWwTYw0=";
=======
    hash = "sha256-R5Q6BbvcAqFNldOqfG1TDoM1gbsYrS3OClHlAdfQG6o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace custom_components/systemair/manifest.json \
      --replace-fail "pymodbus==" "pymodbus>=" \
  '';

  dependencies = [
    pymodbus
    async-timeout
    aiohttp
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE ventilation units";
    homepage = "https://github.com/AN3Orik/systemair";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/AN3Orik/systemair/releases/tag/v${version}";
    description = "Home Assistant component for Systemair SAVE ventilation units";
    homepage = "https://github.com/AN3Orik/systemair";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
