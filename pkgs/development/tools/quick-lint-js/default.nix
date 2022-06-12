{ cmake, fetchFromGitHub, lib, ninja, stdenv, testers, quick-lint-js }:


stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "0vx6fddd0y8p27znv0ah0gjigs9hkifz132vzsnfg7w4s5az4fiy";
  };

  nativeBuildInputs = [ cmake ninja ];
  doCheck = true;

  passthru.tests = {
    version = testers.testVersion { package = quick-lint-js; };
  };

  meta = with lib; {
    description = "Find bugs in Javascript programs";
    homepage = "https://quick-lint-js.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ratsclub ];
    platforms = platforms.all;
  };
}
