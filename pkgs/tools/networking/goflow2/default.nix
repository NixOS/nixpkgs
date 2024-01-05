{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goflow2";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c+1Y3OTM2FR9o7zWYGW3uH1LQ2U1occf1++Rnf/atVQ=";
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
