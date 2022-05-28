{ lib, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoModule rec {
  pname = "clair";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6nlVcuWAp9lWji4ruAZ//D6iEbL+zSjLDX9bYyRfTQ8=";
  };

  vendorSha256 = "sha256-35rUeDi+7xSI2kSk9FvtubxhZq5LePNoXC66dIy6gs8=";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "cmd/clair" "cmd/clairctl" ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    changelog = "https://github.com/quay/clair/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
