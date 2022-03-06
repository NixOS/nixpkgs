{ lib, buildGoModule, fetchFromGitHub, makeWrapper, go }:

buildGoModule rec {
  pname = "xk6";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3jA4e7EL/7wMETjX15JMmTMLCb+b+4MW6XhHeyj+dO8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "./cmd/xk6" ];

  vendorSha256 = null;

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/xk6 --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "Build k6 with extensions";
    homepage = "https://k6.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
