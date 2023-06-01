{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goflow2";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0E3iSO+ObaPhIUerF4y5UygJMSMJNTJwI6RqHunqrZ0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-tNrCsCKBoUsrCOlbI1FUoksWoI4jUiYLF+A8Fjfe9Qk=";

  meta = with lib; {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuka ];
  };
}
