{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "sleep-on-lan";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SR-G";
    repo = pname;
    rev = "${version}-RELEASE";
    sha256 = "sha256-WooFGIdXIIoJPMqmPpnT+bc+P+IARMSxa3CvXY9++mw=";
  };

  sourceRoot = "source/src";
  vendorSha256 = "sha256-JqDDG53khtDdMLVOscwqi0oGviF+3DMkv5tkHvp1gJc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildVersion=${version}"
    "-X main.BuildVersionLabel=nixpkgs"
  ];

  meta = with lib; {
    homepage = "https://github.com/SR-G/sleep-on-lan";
    description = "Multi-platform process allowing to sleep on LAN a linux or windows computer, through wake-on-lan (reversed) magic packets or through HTTP REST requests.";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ devusb ];
  };
}
