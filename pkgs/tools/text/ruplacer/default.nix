{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yj753d9wsnp4s5a71ph241jym5rfz3161a1v3qxfc4w23v86j1q";
  };

  cargoSha256 = "12c3vx56fcdc951vnlrwv6m50k7rwhgkna0g5792gi5kfcc2781s";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  meta = with lib; {
    description = "Find and replace text in source files";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
