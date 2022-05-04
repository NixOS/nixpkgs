{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7dSBac+rLedgko4KLVS9ZWrj/IlXJMsnbQFzyQxv4LQ=";
  };

  cargoSha256 = "sha256-stDxDBftIVZqgy49VGJHx+JTzflVE91QN75aSWhvgSs=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
