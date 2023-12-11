{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0Er8MqAqKCyz928bdbYRO3D9sGZ/JJBrCXhlq9M2dEA=";
  };

  vendorHash = "sha256-J4/a4ujM7A6bDwRlLCYt/PmJf6HZUmdYcJMux/3KyUI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "Markdown defined task runner";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda joerdav ];
  };
}
