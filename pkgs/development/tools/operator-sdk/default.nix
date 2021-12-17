{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+AWkzv6SI/d3p1ljopSyLg2qi1hv6PsynmVG7+lUSTw=";
  };

  vendorSha256 = "sha256-jYBkC0IA2xbRa+56CW/5EWG8sYg3eRuFdLpOFSinuuw=";

  doCheck = false;

  subPackages = [ "cmd/operator-sdk" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ go ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;
  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
