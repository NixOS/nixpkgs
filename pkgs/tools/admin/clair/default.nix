{ lib, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoModule rec {
  pname = "clair";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ns02Yi0FJPOCpjr1P5c1KOkRZ8saxQzXg/Zn5vYLztU=";
  };

  vendorSha256 = "sha256-aFaeRhg+aLOmS7VFbgdxaEtZcBKn9zCVINad6ahpDCo=";

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
