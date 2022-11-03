{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "zgrab2";
  version = "20210327-${lib.strings.substring 0 7 rev}";
  rev = "17a5257565c758e2b817511d15476d330be0a17a";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    inherit rev;
    sha256 = "1hxk2jggj8lww97lwmks46i001p5ycnxnck8yya6d0fd3ayxvw2w";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-qJCIvwTcDPeb5/4BdssbuzAnny5ngbIyFS346HdDPYM=";

  subPackages = [ "cmd/zgrab2" ];

  meta = with lib; {
    description = "Web application scanner";
    homepage = "https://github.com/zmap/zgrab2";
    license = with licenses; [ asl20 isc ];
    maintainers = with maintainers; [ fab ];
  };
}
