{ lib, buildGoModule, fetchFromGitHub, subPackages ? [] }:

buildGoModule rec {
  pname = "cilium";
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    rev = "v${version}";
    sha256 = "sha256-0l+WENMh4Tewe1FOWhwbOn6b8jYgbifyuFuaGOYX6nk=";
  };

  vendorSha256 = null;

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.Program=cilium"
  ];

  inherit subPackages;

  # level=error msg="unable to open \"/sys/devices/system/cpu/possible\"" error="open /sys/devices/system/cpu/possible: no such file or directory" subsys=datapath-loader
  doCheck = false;

  meta = with lib; {
    description = "Cilium CNI plugin";
    homepage = "https://github.com/cilium/cilium/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
