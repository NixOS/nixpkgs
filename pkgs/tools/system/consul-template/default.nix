{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "consul-template";
<<<<<<< HEAD
  version = "0.33.0";
=======
  version = "0.31.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-78RYFFpsW6onWd1aAxDf28GUblIGVtg0uZeURZPla8E=";
  };

  vendorHash = "sha256-LRH3wMRSHIpavXSupFA9HLojBqWVObQfL+SM8ah4oBg=";
=======
    hash = "sha256-6B6qijC10WOyGQ9159DK0+WSE19fXbwQc023pkg1iqQ=";
  };

  vendorHash = "sha256-wNZliD6mcJT+/U/1jiwdYubYe0Oa+YR6vSLo5vs0bDk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) consul-template;
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud pradeepchhetri ];
  };
}
