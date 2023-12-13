{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-cSQDQlc8LgKc9wfJIzXcuaC2GJf46wSwYnmIwMo5ra0=";
  };

  vendorHash = "sha256-laAqRfu1PIheoGksiM3aZHUdmLpDGsTGBmoenh7Yh9w=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
