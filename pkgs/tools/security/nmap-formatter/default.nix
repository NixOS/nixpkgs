{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Jhjvtk8SDs//eBW+2+yLcIXf/NetfBUrKvzKCj+VyMg=";
  };

  vendorSha256 = "sha256-u36eHSb6YlGJNkgmRDclxTsdkONLKn8J/GKaoCgy+Qk=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
