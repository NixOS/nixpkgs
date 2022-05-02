{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pouf";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "1dgk2g13hz64vdx9sqkixl0321cnfnhrm7hxp68vwfcfx3gvfjv8";
  };

  cargoSha256 = "0ipyc9l9kr7izh3dmvczq1i7al56yiaz20yaarz8bpsfcrmgwy3s";

  postInstall = "make PREFIX=$out copy-data";

  meta = with lib; {
    description = "A cli program for produce fake datas.";
    homepage = "https://github.com/mothsart/pouf";
    changelog = "https://github.com/mothsart/pouf/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
  };
}
