{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  ouilookup,
  scapy,
}:

buildHomeAssistantComponent rec {
  owner = "cyberjunky";
  domain = "arpscan_tracker";
  version = "2.2.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-arpscan_tracker";
    tag = version;
    hash = "sha256-IzjqyW5hsbOwJvPykQw7lTbUucQZBY7c1LGkvpz3PQo=";
  };

  dependencies = [
    ouilookup
    scapy
  ];

  meta = {
    changelog = "https://github.com/cyberjunky/home-assistant-arpscan_tracker/releases/tag/${version}";
    description = "Device tracker that discovers network devices with ARP scans";
    homepage = "https://github.com/cyberjunky/home-assistant-arpscan_tracker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
