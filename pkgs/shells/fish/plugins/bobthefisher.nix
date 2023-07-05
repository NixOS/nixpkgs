{ lib
, buildFishPlugin
, fetchFromGitHub
,
}:
buildFishPlugin rec {
  pname = "bobthefisher";
  version = "unstable-2023-03-09";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "bobthefisher";
    rev = "6528033a2c9ca90611d04b6a4afd2131b9495cdc";
    sha256 = "sha256-UDoSMFKtd6ur10guqJlkpA0YSCBv45FR5QKJqdXZWgw=";
  };

  meta = with lib; {
    description = "A Powerline-style, Git-aware fish theme optimized for awesome (fork of bobthefish)";
    homepage = "https://github.com/Scrumplex/bobthefisher";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
