{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "shellz";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mhl1y0jkycyl1hgwxavxkm1f6kdx1sz3bvpmkr46sdijji06imi";
  };

  vendorSha256 = "14rd9xd7s5sfmxgv5p9ka8x12xcimv5hrq7hzy0d1c3ddf50rr7n";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Utility to manage your SSH, telnet, kubernetes, winrm, web or any custom shell";
    homepage = "https://github.com/evilsocket/shellz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
