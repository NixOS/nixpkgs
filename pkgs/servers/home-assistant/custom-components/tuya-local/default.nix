{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, tinytuya
}:

buildHomeAssistantComponent rec {
  owner = "make-all";
  domain = "tuya_local";
  version = "2024.2.1";

  src = fetchFromGitHub {
    owner = "make-all";
    repo = "tuya-local";
    rev = version;
    hash = "sha256-mFqx5TlKfyUV1l+2sG3+NxznSwT3MSeFJi+GM3Hgdzw=";
  };

  propagatedBuildInputs = [
    tinytuya
  ];

  meta = with lib; {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local/";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
  };
}
