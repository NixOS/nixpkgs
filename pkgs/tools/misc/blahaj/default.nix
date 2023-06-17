{ lib
, crystal
, fetchFromGitHub
}:

crystal.buildCrystalPackage rec {
  pname = "blahaj";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "BLAHAJ";
    rev = "v${version}";
    hash = "sha256-drdC507lIYanHS7fneW9Xwqmyr6f1oGF1+xeYQ2DzKA=";
  };

  meta = with lib; {
    description = "Gay sharks at your local terminal - lolcat-like CLI tool";
    homepage = "https://blahaj.queer.software";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aleksana ];
  };
}
