{ lib, fetchFromGitHub, buildGoModule, callPackage, enableWebui ? true }:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rb81CbtC1V8AugTNIGx07CvK20sZ5d4hfc4OxF259IQ=";
  };

  vendorHash = "sha256-Rr2EVrQOdlOqSlTpXFMfnKNmdw6UiT7LZH0xBUwqkJc=";

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
