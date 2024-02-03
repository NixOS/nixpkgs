{ lib
, buildHomeAssistantComponent
, fetchFromGitea
, libgpiod
}:

buildHomeAssistantComponent rec {
  owner = "raboof";
  domain = "gpio";
  version = "0.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "raboof";
    repo = "ha-gpio";
    rev = "v${version}";
    hash = "sha256-oito5W7uQYgxUQFIynW9G7jbIpmFONWC8FslRdX3gsE=";
  };

  propagatedBuildInputs = [ libgpiod ];

  meta = with lib; {
    description = "Home Assistant GPIO custom integration";
    homepage = "https://codeberg.org/raboof/ha-gpio";
    maintainers = with maintainers; [ raboof ];
    license = licenses.asl20;
  };
}
