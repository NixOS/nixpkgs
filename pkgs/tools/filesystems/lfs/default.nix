{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3zGCVT3SfQm72CF2MasT7k5r1Jx9DRUrXKHBSpvcv10=";
  };

  cargoSha256 = "sha256-Q4eNvOY5c4KybDKVhcOznxGPUgyjgEYPD8+9r6sECXA=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
