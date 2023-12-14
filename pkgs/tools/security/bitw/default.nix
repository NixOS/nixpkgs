{ fetchFromGitHub, buildGoModule, nixosTests, lib }:
buildGoModule rec {
  pname = "bitw";
  version = "unstable-2023-04-08";

  vendorHash = "sha256-L6kHDZt0+QMC9BCBgh0CMyfD1lCb8ymq1sl4QqoCGH0=";

  # Requires connection to bitwarden.com.
  doCheck = false;

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "bitw";
    rev = "b6162395999b253c7ddff7d3a40b380a4a373ec7";
    sha256 = "0fglyw5gidybzyjlqi255yqrgdx1dp1a4jb5in4gfa9p87gd6nvm";
  };

  passthru.tests = [ nixosTests.vaultwarden ];
  meta = with lib; {
    homepage = "https://github.com/mvdan/bitw";
    description = "Bitwarden client implementing the freedesktop secrets API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lheckemann ma27 hexa raitobezarius ];
  };
}
