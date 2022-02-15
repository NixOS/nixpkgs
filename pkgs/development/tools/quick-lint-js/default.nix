{ cmake, fetchFromGitHub, lib, ninja, stdenv }:

stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "sha256-F21eli4HdLw3RComvocwBrcGfruIjO23E6+7a4+6vbs=";
  };

  nativeBuildInputs = [ cmake ninja ];
  doCheck = true;

  meta = with lib; {
    description = "Find bugs in Javascript programs";
    homepage = "https://quick-lint-js.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ratsclub ];
    platforms = platforms.all;
  };
}
