{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "joincap";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "assafmo";
    repo = "joincap";
    rev = "v${version}";
    hash = "sha256-Xli9G/VkDWKkc+7mldmLfvigvPPcdcToc4e15uoadDQ=";
  };

  vendorHash = "sha256-YsLIbt3uiA1d08yIEhSRdep1+52AxRvbIzDHlhc5s7Y=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Merge multiple pcap files together, gracefully";
    mainProgram = "joincap";
    homepage = "https://github.com/assafmo/joincap";
    changelog = "https://github.com/assafmo/joincap/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
