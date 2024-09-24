{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  schiene,
}:

buildHomeAssistantComponent rec {
  owner = "FaserF";
  domain = "deutschebahn";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "FaserF";
    repo = "ha-deutschebahn";
    rev = "refs/tags/${version}";
    hash = "sha256-NGgtPqhTAcYYimDquEv2N0dY+L0KxRKR4yuB8zFbmdo=";
  };

  propagatedBuildInputs = [
    schiene
  ];

  meta = with lib; {
    description = "Unofficial HA DB Integration, due to removal as of Home Assistant 2022.11";
    homepage = "https://github.com/FaserF/deutschebahn";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.asl20;
  };
}
