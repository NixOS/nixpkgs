{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    sha256 = "sha256-Zczj2HQkm6/hXH24pOXYT5r7RS/SI/39s5XtNnc7f9o=";
  };

  cargoSha256 = "sha256-mjekXjHhi8gxjD47DmTs3TGtnXp3FbxiIq7Uo+rOvKc=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
