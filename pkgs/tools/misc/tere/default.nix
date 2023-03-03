{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "sha256-gEoy7pwZxlCIPTQZVPSo5TIdmSliSSePunXO3hD3Ryo=";
  };

  cargoSha256 = "sha256-4XvVisRLSHw4jz+nUndWzS1IK2tnzmxdcgqNHHOvkQg=";

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
