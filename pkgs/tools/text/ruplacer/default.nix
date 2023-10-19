{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xuq+Scy5MyyGvI51Vs26pk9+NnlghzGEJDHYC3kSXNw=";
  };

  cargoHash = "sha256-Kevwpkvgq40LhWxhW9ra2Nd1zEiAF372DM1sY9hnQb0=";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
