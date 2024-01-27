{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lTbTD5t80+R9hQeytNE2/Cs8dofdiYEP3zkc084mdAA=";
  };

  vendorHash = "sha256-TrCIUeY0B+BsWNaUkDTEgrEaWfJKnID2mafj3ink+i8=";

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "cipher/decipher text within a file";
    homepage = "https://github.com/mvisonneau/s5";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ mvisonneau ];
  };
}
