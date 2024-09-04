{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.31.3";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-7B6dRulnSPD5s2w4nTXBPxJUCRvKD9++/Y1BMNm2ZwM=";
  };

  npmDepsHash = "sha256-FMd2bbMHzo38/zJuOlpzGtRPwuoxmZJF/XF2KgTP2ak=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
