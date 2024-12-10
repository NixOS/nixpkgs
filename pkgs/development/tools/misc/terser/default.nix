{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.30.4";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-d0zxwUvXa+Nm9p8QkhBhXl73XfJ+dxxt+GHkFtI8Zuk=";
  };

  npmDepsHash = "sha256-7j3hMDVktQxolCMM27SH7y5ZtexnwF//ccilVZ0w5l8=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
