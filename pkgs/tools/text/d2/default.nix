{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "d2";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2abGQmgwqxWFk7NScdgfEjRYZF2rw8kxTKRwcl2LRg0=";
  };

  vendorSha256 = "sha256-/BEl4UqOL4Ux7I2eubNH2YGGl4DxntpI5WN9ggvYu80=";

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  subPackages = [ "cmd/d2" ];

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
