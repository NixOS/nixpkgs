{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wakapi";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-lBjYtb64blFUH/iW/SmC4A7nX9asokvsNKu6QVYgmZ8=";
  };

  vendorHash = "sha256-Kt7RzAGZeLFhwvq+V6AK88rivqkoTE1Zep7NMh3BXXQ=";

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
    description = "Minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "wakapi";
  };
}
