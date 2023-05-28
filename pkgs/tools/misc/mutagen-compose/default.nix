{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rn3aXwez/WUGpuRvA6lkuECchpYek8KDMh6xzZOV9v0=";
  };

  patches = [
    ./1.16.5-CVE-2023-30844.patch
  ];

  vendorSha256 = "sha256-LhZlwWVb3Xix7h6ja1UTBr/4Py6tNEZT/lMgBeUmrHA=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
