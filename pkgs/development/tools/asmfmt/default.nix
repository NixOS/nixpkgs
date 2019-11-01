{ buildGoPackage
, lib
, fetchFromGitHub
, fetchpatch
}:

buildGoPackage rec {
  pname = "asmfmt";
  version = "1.1";

  goPackagePath = "github.com/klauspost/asmfmt";

  src = fetchFromGitHub {
    owner = "klauspost";
    repo = "asmfmt";
    rev = "v${version}";
    sha256 = "08mybfizcvck460axakycz9ndzcgwqilp5mmgm4bl8hfrn36mskw";
  };

  patches = [
    (fetchpatch {
      excludes = ["README.md"];
      url = "https://github.com/klauspost/asmfmt/commit/39a37c8aed8095e0fdfb07f78fc8acbd465d9627.patch";
      sha256 = "18bc77l87mf0yvqc3adlakxz6wflyqfsc2wrmh9q0nlqghlmnw5k";
    })
  ];

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Go Assembler Formatter";
    homepage = https://github.com/klauspost/asmfmt;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
