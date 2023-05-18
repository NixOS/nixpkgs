{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goflow2";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YZuF3O1/Ycn2gFK9i1D/W8F16B6NEift5PYbv8yqUHk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-c40N6SAym9dpCuGb5I7t9sJBde2r552obot3drYCjB4=";

  meta = with lib; {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuka ];
  };
}
