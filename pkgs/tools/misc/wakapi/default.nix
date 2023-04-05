{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-yMxcePwBUteqrdfvDjZSRInOXMFmwaFoVBihcMQFTME=";
  };

  vendorHash = "sha256-sfx8qlmJrS0hkD6DSvKqfnBDbxj8eNA3hnprSwA2fSI=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "A minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ t4ccer ];
  };
}
