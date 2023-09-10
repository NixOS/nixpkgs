{ lib, stdenv, buildGoModule, fetchFromGitea, nixosTests }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230729";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "eris-go";
    rev = version;
    hash = "sha256-yFWmfWmlGL4fC36XsjO/ao/v8FVI20EpXSblZ0EcosI=";
  };

  vendorHash = "sha256-Z6rirsiiBzH0herQAkxZp1Xr++489qNoiD4fqoLt9/A=";

  passthru.tests = { inherit (nixosTests) eris-server; };

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    homepage = "https://codeberg.org/eris/eris-go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    broken = stdenv.isDarwin;
  };
}
