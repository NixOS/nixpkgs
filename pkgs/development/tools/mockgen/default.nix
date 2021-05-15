{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "mockgen";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "golang";
    repo = "mock";
    rev = "v${version}";
    sha256 = "sha256-YSPfe8/Ra72qk12+T78mTppvkag0Hw6O7WNyfhG4h4o=";
  };
  vendorSha256 = "sha256-cL4a7iOSeaQiG6YO0im9bXxklCL1oyKhEDmB1BtEmEw=";

  doCheck = false;

  subPackages = [ "mockgen" ];

  meta = with lib; {
    description = "GoMock is a mocking framework for the Go programming language";
    homepage = "https://github.com/golang/mock";
    license = licenses.asl20;
    maintainers = with maintainers; [ bouk ];
  };
}
