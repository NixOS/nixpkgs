{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v9xVJFX3YJQU9z9L7dhy0S1FvpWoDad36Lq3w4VW0xA=";
  };

  vendorSha256 = "sha256-8/EGoY3+th34gAACDoEHgwhUFmyyKecnQP/WTe56iCQ=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
