{ cmake, fetchFromGitHub, lib, ninja, stdenv }:

stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "09jp118n487g467d4zhqcpnwwrvmjw02ssv1rbyw2s22cgz9701f";
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
