{ lib, fetchFromGitHub, buildGoModule, callPackage, enableWebui ? true }:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.13.2";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7lVNbqQv6MNIhHMFbH8VFVIjKiuTCbeVkAKeGprzrkw=";
  };

  vendorHash = "sha256-Pz/TtGjwGHaDSueBEHMtHjyAxYO5V+8jzXCowHcUW/4=";

  ui = callPackage ./webui.nix { inherit version src; };

  postPatch = if enableWebui then ''
    mkdir -p ui/build
    cp -r ${ui}/* ui/build
  '' else ''
    sed -i '/go:/d' ui/assets.go
  '';

  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pacien martinetd ];
    mainProgram = "rmfakecloud";
  };
}
