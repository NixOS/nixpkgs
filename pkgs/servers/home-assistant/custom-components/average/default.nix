{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "Limych";
  domain = "average";
  version = "2.3.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-average";
    rev = version;
    hash = "sha256-PfN2F1/ScVScXfh5jKQDZ6rK4XlqD9+YW8k4f4i3bk0=";
  };

  meta = with lib; {
    description = "Average Sensor for Home Assistant";
    homepage = "https://github.com/Limych/ha-average";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.cc-by-nc-40;
  };
}
