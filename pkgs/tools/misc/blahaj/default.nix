{ lib
, crystal
, fetchFromGitHub
}:

crystal.buildCrystalPackage rec {
  pname = "blahaj";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "BLAHAJ";
    rev = "v${version}";
    hash = "sha256-CmMF9jDKUo+c8dYc2UEHKdBDE4dgwExcRS5sSUsUJik=";
  };

  meta = with lib; {
    description = "Gay sharks at your local terminal - lolcat-like CLI tool";
    homepage = "https://blahaj.queer.software";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aleksana cafkafk ];
    mainProgram = "blahaj";
  };
}
