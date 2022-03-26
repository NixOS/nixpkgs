{ cmake, fetchFromGitHub, lib, ninja, stdenv }:

stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "1ay59pmprcswip6zzbqfy5g2rdv4lgmps8vrxay4l9w6xn9lg03v";
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
