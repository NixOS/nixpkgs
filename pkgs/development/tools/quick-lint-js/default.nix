{ cmake, fetchFromGitHub, lib, ninja, stdenv, testers, quick-lint-js }:


stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "122z6wnmf5lk6pvwj5065470kvkbb8jqc32x0nw6103fnak5cyih";
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
