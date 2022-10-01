{ lib, buildGoModule, fetchFromGitHub, libpcap }:

buildGoModule rec {
  pname = "httpdump";
  version = "unstable-2022-07-27";

  src = fetchFromGitHub {
    owner = "hsiafan";
    repo = pname;
    rev = "49c42ed00eb34bec5e1c7926bbf6272f47b7dafb";
    sha256 = "sha256-Teyg4EjFP2wq8yCV+jGpvUyzpsnJ55oqrOedko1IIcQ=";
  };

  vendorSha256 = "sha256-i18RkxuTyoz6+td1dYi2bGJP6SsZuBd/uRDDqqY04Go=";

  propagatedBuildInputs = [ libpcap ];

  meta = with lib; {
    description = "Parse and display HTTP traffic from network device or pcap file";
    homepage = "https://github.com/hsiafan/httpdump";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
