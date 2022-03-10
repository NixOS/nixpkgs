{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nzhzeXy70UQ1HP3/PCBnUPhrjg7CnKURMCH0iJ099E0=";
  };

  vendorSha256 = "sha256-uQRAVbLnzY+E3glMJ3AvmbtmwD2LkuqCh2mUpqZbmaA=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
