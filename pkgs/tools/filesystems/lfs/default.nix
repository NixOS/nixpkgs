{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nRJ73j3l3xaFImhrHEGmfqESEEjVKhIwdNZNc/RqOcU=";
  };

  cargoSha256 = "sha256-iAz2s92hWkLCXoQ09mKCyI0yHvH55WaTSl+a5gz44bU=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
