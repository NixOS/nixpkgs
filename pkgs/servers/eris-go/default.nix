{ lib, stdenv, buildGoModule, fetchFromGitea, nixosTests }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230904";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "eris-go";
    rev = version;
    hash = "sha256-HwXjF0VypN2AktYA3jNuVPmParZDYxQcZcJPrEDAFTU=";
  };

  vendorHash = "sha256-Z6rirsiiBzH0herQAkxZp1Xr++489qNoiD4fqoLt9/A=";

  passthru.tests = { inherit (nixosTests) eris-server; };

  skipNetworkTests = true;

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    homepage = "https://codeberg.org/eris/eris-go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    broken = stdenv.isDarwin;
  };
}
