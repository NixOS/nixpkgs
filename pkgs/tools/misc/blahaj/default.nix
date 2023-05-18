{ lib
, crystal
, fetchFromGitHub
}:

crystal.buildCrystalPackage rec {
  pname = "blahaj";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "BLAHAJ";
    rev = "v${version}";
    hash = "sha256-g38a3mUt2bkwFH/Mwr2D3zEZczM/gdWObUOeeIJGHZ4=";
  };

  meta = with lib; {
    description = "Gay sharks at your local terminal - lolcat-like CLI tool";
    homepage = "https://blahaj.queer.software";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aleksana ];
  };
}
