{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.24.5";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/sTagdlWU6hU3TTeJcZ8WK4TqmvxgUbC5eLBz2FH6Jo=";
  };

  vendorSha256 = "sha256-NHu1hZFPT2k8izrvvz7w0vlVe/nKH0nS4oXUGS8CWcc=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
