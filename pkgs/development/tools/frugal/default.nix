{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.17.13";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-giPlv3pf0hz2zlQ/9o12SGfwFLCtpN96tfQwP9AaPNo=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-DCSS2kH2yco8cfbQBw3IZHcEE4BP5ir7ikxsIsFDqg0=";

  meta = with lib; {
    description = "Thrift improved";
    mainProgram = "frugal";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
