{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.18";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fIEHv0xO/dXof6ED99uCC0y8dF9fBkK5FFtvpoIfbKk=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-vSUyxjVAmOKh4kcNoC25cDZEuparsJ7FDIslzOy8CNo=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
