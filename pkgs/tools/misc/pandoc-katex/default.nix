{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pandoc-katex";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "xu-cheng";
    repo = pname;
    rev = version;
    hash = "sha256-TGilWr/Q8K+YP6FYfZqJOwtTAFiY+YX7AAole4TiSoE=";
  };

  cargoSha256 = "sha256-CEyS7dMG+5e/LwEKdYlHFVCBm2FPKVjJlrMFB+QGm+Y=";

  meta = with lib; {
    description = "Pandoc filter to render math equations using KaTeX";
    homepage = "https://github.com/xu-cheng/pandoc-katex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ minijackson pacien ];
  };
}
