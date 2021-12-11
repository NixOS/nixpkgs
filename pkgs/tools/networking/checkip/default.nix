{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XIrGza8yMC1lrSXiaEADcft4UkaZ33R6LW4ug0+8sxs=";
  };

  vendorSha256 = "sha256-4XA7B0gmFE52VoKiPLsa0urPS7IdzrTBXuU4wZv/Lag=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
