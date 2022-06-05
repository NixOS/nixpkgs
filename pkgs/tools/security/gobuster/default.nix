{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    sha256 = "0nal2g5c6z46x6337yh0s6mqgnsigp91i7mp1l3sa91p5ihk71wr";
  };

  vendorSha256 = "1isp2jd6k4ppns5zi9irj09090imnc0xp6vcps135ymgp8qg4163";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
