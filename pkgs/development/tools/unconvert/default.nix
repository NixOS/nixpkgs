{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "unconvert";
  version = "unstable-2020-02-28";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "95ecdbfc0b5f3e65790c43c77874ee5357ad8a8f";
    sha256 = "sha256-jC2hbpGJeW9TBWIWdeLeGaoNdsm/gOKY4oaDsO5Fwlw=";
  };

  vendorSha256 = "sha256-HmksSYA4974w+J/7PkMKEkXEfIkldj+kVywvsfLgE38=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Remove unnecessary type conversions from Go source";
    homepage = "https://github.com/mdempsky/unconvert";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
