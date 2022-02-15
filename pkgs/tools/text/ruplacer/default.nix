{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5r1OywctKAeSBPzjYSPith1QNxRH0hman7lnSym2XIY=";
  };

  cargoSha256 = "sha256-JrVPEuGBVo+NCsZ1DH/Af8OLWiNXnQIBxiOukw+W5Qo=";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
