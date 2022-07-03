{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Zs8vyPD1BpjA5EXzeKyfv9CzhD0iIp1LNLlqCp+zpaY=";
  };

  vendorSha256 = "sha256-Wln6vf9FJ1VJgdll5a7QS+M6PCM151EB8aOb9fFkSXo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
