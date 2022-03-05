{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "jfmt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "scruffystuffs";
    repo = "${pname}.rs";
    rev = version;
    sha256 = "07qb0sjwww6d2n7fw8w4razq1mkn4psrs9wqi1ccndrya1y39d8b";
  };

  cargoSha256 = "19kg2n53y9nazwpp8gcvdprxry2llf2k7g4q4zalyxkhpf7k6irb";

  meta = with lib; {
    description = "CLI utility to format json files";
    homepage = "https://github.com/scruffystuffs/jfmt.rs";
    license = licenses.mit;
    maintainers = [ maintainers.psibi ];
  };
}
