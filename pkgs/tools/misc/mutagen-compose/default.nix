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

  vendorHash = "sha256-EkLeB2zUJkKCWsJxMiYHSDgr0/8X24MT0Jp0nuYebds=";

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
