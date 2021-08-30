{ lib, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoModule rec {
  pname = "clair";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PVR7QMndjfCNVo9U3lnArpRBxLfmOH8iEdFub7hZyio=";
  };

  vendorSha256 = "sha256-npskCUVxNTgI8egVU1id02xHFfTizOb7kBUNfOLdbOc=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

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
