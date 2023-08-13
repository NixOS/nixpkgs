{ cmake, fetchFromGitHub, lib, ninja, stdenv, testers, quick-lint-js }:


stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "sha256-jymn3xqFwAKskBivkm9s/pLkPLpX1haQhNuH18xgiYw=";
  };

  nativeBuildInputs = [ cmake ninja ];
  doCheck = true;

  # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=ON" ];

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
