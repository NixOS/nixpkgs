{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "003l4v7d671rvw7q32fxhxv3qazw6v8v9ch7hmyy9lvwkc7x6dlm";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorSha256 = "TrCIUeY0B+BsWNaUkDTEgrEaWfJKnID2mafj3ink+i8=";
  doCheck = true;

  meta = with lib; {
    description = "cipher/decipher text within a file";
    homepage = "https://github.com/mvisonneau/s5";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ mvisonneau ];
  };
}
