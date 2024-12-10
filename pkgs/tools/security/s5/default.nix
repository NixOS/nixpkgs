{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "s5";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-asX61mGgXKlSvVGcGrfVGLiZersjbaVql1eKf+b9JmU=";
  };

  vendorHash = "sha256-8nuhRoFnN2oiJdo7bXxHqaHTkZH9Hh2Q2cYnMkEt4kI=";

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "cipher/decipher text within a file";
    mainProgram = "s5";
    homepage = "https://github.com/mvisonneau/s5";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ mvisonneau ];
  };
}
