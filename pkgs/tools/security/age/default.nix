{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-beta2";
  goPackagePath = "github.com/FiloSottile/age";
  modSha256 = "0kwdwhkxgqjd8h1p7pm4h4xidp2vk840h1j4qya4qz8bjf9vskl9";

  subPackages = [
    "cmd/age"
    "cmd/age-keygen"
  ];

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "1n1ww8yjw0mg00dvnfmggww9kwp1hls0a85iv6vx9k89mzv8mdrq";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
