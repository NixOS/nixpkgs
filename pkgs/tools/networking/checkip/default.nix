{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.38.5";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZwrwBWhji/moT1dQBCkMP5DI+xEfE6dGtZerFubobjc=";
  };

  vendorSha256 = "sha256-cahrJvPSemlEpaQ1s4bbi1yp0orTDGOoanqXDVVIpjQ=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
