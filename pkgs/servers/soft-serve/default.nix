{ lib, buildGoModule, fetchFromGitHub, makeWrapper, nixosTests, git, bash }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    hash = "sha256-pJ8rh0WRpkyNH2zhfN8AVDZT5F690k6xhP+PSqB1JMI=";
  };

  vendorHash = "sha256-t2Ciulzs/7dYFCpiX7bo0hwwImJBkRV2I1aTT2lQm+M=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Soft-serve generates git-hooks at run-time.
    # The scripts require git and bash inside the path.
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git bash ]}"
  '';

  passthru.tests = nixosTests.soft-serve;

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
