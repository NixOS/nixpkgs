{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nix-simple-deploy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "misuzu";
    repo = pname;
    rev = version;
    sha256 = "12g0sbgs2dfnk0agp1kagfi1yhk26ga98zygxxrjhjxrqb2n5w80";
  };

  cargoSha256 = "1wp8wdv25j8ybq2j04z3nl4yc95wkj5h740lzpyps08yaxj8bncr";

  meta = with lib; {
    description = "Deploy software or an entire NixOS system configuration to another NixOS system";
    homepage = "https://github.com/misuzu/nix-simple-deploy";
    license = with licenses; [ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
