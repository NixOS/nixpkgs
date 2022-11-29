{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I/VN2KCI38uADLpLAJbkhTU3AG40ECYVMAqLVajhsw0=";
  };

  vendorSha256 = "sha256-RfkY66879Us0UudplMzW8xEC1zs+2OXwyB+nBim3I0I=";

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
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
