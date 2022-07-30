{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q9zymQW8XWApy5ssfMtojN4AhteqrQzZyMeAkOsJDyw=";
  };

  vendorSha256 = "sha256-NwDaPpjkQogXE37RGS3zEALlp3NuXP9RW//vbwM6y0A=";

  postPatch = ''
    # skip including the JS SPA, which is difficult to build
    sed -i '/go:/d' ui/assets.go
  '';

  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pacien martinetd ];
  };
}
