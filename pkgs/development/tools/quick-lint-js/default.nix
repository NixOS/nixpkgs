{ cmake, fetchFromGitHub, lib, ninja, stdenv, testVersion, quick-lint-js }:


stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "sha256-3DiK7c+RuCIy9B2j6ozSaVIRf63o9S8uH27SZZJHjes=";
  };

  nativeBuildInputs = [ cmake ninja ];
  doCheck = true;

  passthru.tests = {
    version = testVersion { package = quick-lint-js; };
  };

  meta = with lib; {
    description = "Find bugs in Javascript programs";
    homepage = "https://quick-lint-js.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ratsclub ];
    platforms = platforms.all;
  };
}
