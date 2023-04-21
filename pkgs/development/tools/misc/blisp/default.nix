{ lib
, stdenv
, fetchFromGitHub
, cmake
, IOKit
, testers
, blisp
,
}:
let
  version = "0.0.4";
in
stdenv.mkDerivation {
  pname = "blisp";
  inherit version;

  src = fetchFromGitHub {
    owner = "pine64";
    repo = "blisp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-FT0CsxPKKWx4vg6f9woc15jgJj9P4fTAzW+s+ClzkwE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBLISP_BUILD_CLI=ON" ];

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  passthru.tests.version = testers.testVersion {
    package = blisp;
    command = "blisp --version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/pine64/blisp";
    description = "An In-System Programming (ISP) tool for Bouffalo Labs RISC-V MCUs";
    longDescription = ''
      In-System Programming (ISP) CLI tool for Bouffalo Labs RISC-V MCUs.

      Used for flashing BL60x, BL61x, BL70x, BL808 SoCs, and products using corresponding MCUs, like Pinecil V2.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ bdd ];
  };
}
