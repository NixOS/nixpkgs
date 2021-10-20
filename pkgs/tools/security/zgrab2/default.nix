{ lib
, buildGoModule
, fetchFromGitHub
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

  vendorSha256 = "1s0azy5b5hi5h24vs6a9f1n70l980vkid28ihqh10zq6ajmds2z3";

  subPackages = [ "cmd/zgrab2" ];

  meta = with lib; {
    description = "Web application scanner";
    homepage = "https://github.com/zmap/zgrab2";
    license = with licenses; [ asl20 isc ];
    maintainers = with maintainers; [ fab ];
  };
}
