{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-xUFYwV9fuTMDEqp4FEyPRDQCB6I/3sqcmEX8pm6BDfw=";
  };

  vendorHash = "sha256-TeKVhG1V9inyDWfILwtpU9QknJ9bt3Dja5GVHrK9PkA=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  # Fix up reported version
  postPatch = ''echo ${version} > version.txt'';

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
    mainProgram = "wakapi";
  };
}
