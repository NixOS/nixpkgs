{ lib, stdenv, fetchFromGitHub, cmake, curl, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastgron";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "adamritter";
    repo = "fastgron";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sGTJ98YEvy+pOFVLLIcvgUq5Pn4r1CYL9YEchZhoBeQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    changelog = "https://github.com/adamritter/fastgron/releases/tag/${finalAttrs.src.rev}";
    description = "High-performance JSON to GRON (greppable, flattened JSON) converter";
    homepage = "https://github.com/adamritter/fastgron";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.all;
  };
})
