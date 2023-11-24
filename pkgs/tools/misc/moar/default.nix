{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.18.4";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zF+Hnsmw5TJCYYoItrwcnyh3NSmKrV9JoTPwTMVyw7Y=";
  };

  vendorHash = "sha256-x6BeU6JDayCOi8T8+NvXZe59QmTaO9RAYwSiFlDPL/c=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s" "-w"
    "-X" "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    mainProgram = "moar";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
