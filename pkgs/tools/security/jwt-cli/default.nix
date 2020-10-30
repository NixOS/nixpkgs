{ stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "07mnkr7hi29fyyyn7llb30p4ndiqz4gf1lnhm44qm09alaxmfvws";
  };

  cargoSha256 = "0jkzy7ssg9v9phhlldq6s4rfs3sn17y2r1k0jr10g9j15lzixa04";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  doInstallCheck = true;
  installCheckPhase = "$out/bin/jwt --version";

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
  };
}
