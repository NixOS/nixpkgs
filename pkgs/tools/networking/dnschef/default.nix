{
  buildPythonApplication,
  fetchFromGitHub,
  dnslib,
  lib,
}:

buildPythonApplication {
  pname = "dnschef";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "iphelix";
    repo = "dnschef";
    rev = "a395411ae1f5c262d0b80d06a45a445f696f3243";
    sha256 = "0ll3hw6w5zhzyqc2p3c9443gcp12sx6ddybg5rjpl01dh3svrk1q";
  };

  format = "other";
  installPhase = ''
    install -D ./dnschef.py $out/bin/dnschef
  '';

  propagatedBuildInputs = [ dnslib ];

  meta = with lib; {
    homepage = "https://github.com/iphelix/dnschef";
    description = "Highly configurable DNS proxy for penetration testers and malware analysts";
    mainProgram = "dnschef";
    license = licenses.bsd3;
    maintainers = [ maintainers.gfrascadorio ];
  };
}
