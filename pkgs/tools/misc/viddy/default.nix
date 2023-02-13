{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AcRfKu6P7b/HsuC6DTezbYLI9rQZwjklH/bs7mKITUk=";
  };

  vendorSha256 = "sha256-QxYM4N3E/BqmeNaofLR1crwFLVaF3IigDXKlKA2Bkuw=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${version}"
  ];

  meta = with lib; {
    description = "A modern watch command";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [ j-hui ];
  };
}
