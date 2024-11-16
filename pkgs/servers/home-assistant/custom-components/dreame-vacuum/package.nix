{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python312Packages,
}:

buildHomeAssistantComponent rec {
  owner = "Tasshack";
  domain = "dreame_vacuum";
  version = "1.0.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "dreame-vacuum";
    rev = "v${version}";
    hash = "sha256-LeKD2dIeC/TsOl3Q2TLFQy7RjzbRwYmvKUUm3JVsz8E=";
  };

  propagatedBuildInputs = with python312Packages; [
    pillow
    numpy
    pybase64
    requests
    pycryptodome
    python-miio
    py-mini-racer
    tzlocal
    paho-mqtt
  ];

  meta = with lib; {
    description = "Home Assistant integration for Dreame robot vacuums with map support";
    homepage = "https://github.com/Tasshack/dreame-vacuum";
    changelog = "https://github.com/Tasshack/dreame-vacuum/releases/tag/${version}";
    maintainers = with maintainers; [ baksa ];
    license = licenses.mit;
  };
}
