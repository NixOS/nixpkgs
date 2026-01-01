{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitea,
  libgpiod,
}:

buildHomeAssistantComponent rec {
  owner = "raboof";
  domain = "gpio";
  version = "0.0.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "raboof";
    repo = "ha-gpio";
    rev = "v${version}";
    hash = "sha256-JyyJPI0lbZLJj+016WgS1KXU5rnxUmRMafel4/wKsYk=";
  };

  dependencies = [ libgpiod ];

<<<<<<< HEAD
  meta = {
    description = "Home Assistant GPIO custom integration";
    homepage = "https://codeberg.org/raboof/ha-gpio";
    maintainers = with lib.maintainers; [ raboof ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Home Assistant GPIO custom integration";
    homepage = "https://codeberg.org/raboof/ha-gpio";
    maintainers = with maintainers; [ raboof ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
