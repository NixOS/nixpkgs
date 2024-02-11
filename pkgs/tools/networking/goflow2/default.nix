{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goflow2";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eI5Czx721aty1b+rs8uHrx0IBM/DK7bkPck1QIYPcNI=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-9Ebrkizt/r60Kxh291CLzwKIkpdQqJuVYQ2umxih9lo=";

  meta = with lib; {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuka ];
  };
}
