{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zkar";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JPkxJpx2guTaEfTYhQsgZG+kXqHXgEiOrS9sk5vOjVc=";
  };

  vendorHash = "sha256-R+Pd3QklWqTuivUy7nRIzCmWSujgXpdfFoXAihGSflk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Java serialization protocol analysis tool";
    homepage = "https://github.com/phith0n/zkar";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "zkar";
  };
}
