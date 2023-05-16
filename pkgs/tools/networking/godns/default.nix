{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "godns";
<<<<<<< HEAD
  version = "2.9.9";
=======
  version = "2.9.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-R5f2h8bodP/9MP5gqGWBEbC/rLPEV4gEDoc5sMgmoLs=";
=======
    hash = "sha256-In0v3WLxUofVaJ78HNDYWKJCjxk9q1GhDg6X2aGg91I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-iAU62/0MjzxwuMvIobhIZEqDJUpRqwEabnazH7jBRTE=";

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    changelog = "https://github.com/TimothyYe/godns/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
  };
}
