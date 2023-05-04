{ lib, stdenv, fetchFromGitHub, curl, python3, python3Packages, trurl, testers }:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "curl";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-/Gf7T67LPzVPhjAqTvbLiJOqfKeWvwH/WHelJZTH4ZI=";
  };

  outputs = [ "out" "dev" "man" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [ curl ];
  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
  nativeCheckInputs = [ python3 python3Packages.packaging ];
  checkTarget = "test";

  passthru.tests.version = testers.testVersion {
    package = trurl;
  };

  meta = with lib; {
    description = "A command line tool for URL parsing and manipulation";
    homepage = "https://curl.se/trurl";
    changelog = "https://github.com/curl/trurl/releases/tag/${pname}-${version}";
    license = licenses.curl;
    maintainers = with maintainers; [ christoph-heiss ];
    platforms = platforms.all;
  };
}
