{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F+Sc3t1GYpGR+EEP+9GpzfaiWNQVpDivzpS66E7Li3A=";
  };

  vendorSha256 = "sha256-aiqnJ1PjrwSC6YtixNvyTxgbs8z2radcETNhKHGlPk0=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
