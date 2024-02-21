{ lib, stdenv, fetchFromGitHub, curl, python3, trurl, testers }:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "curl";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-/eivtsxNzW6IlX08Zfnj06C1kdaaRs4yvqLlbBuo8ec=";
  };

  # The version number was forgotten to be updated for the release,
  # so do it manually in the meantime.
  # See https://github.com/curl/trurl/discussions/244#discussioncomment-7436369
  postPatch = ''
    substituteInPlace version.h --replace 0.8 0.10
  '';

  outputs = [ "out" "dev" "man" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [ curl ];
  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
  nativeCheckInputs = [ python3 ];
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
    mainProgram = "trurl";
  };
}
