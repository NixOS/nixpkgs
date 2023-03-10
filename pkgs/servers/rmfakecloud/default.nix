{ lib, fetchFromGitHub, buildGoModule, callPackage, enableWebui ? true }:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xBKo+qwwgGMOb+B1aI0pwH8u8c1GNZSXfhVd4SNewdg=";
  };

  vendorSha256 = "sha256-NwDaPpjkQogXE37RGS3zEALlp3NuXP9RW//vbwM6y0A=";

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
  };
}
