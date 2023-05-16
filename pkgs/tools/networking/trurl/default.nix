<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, curl, python3, trurl, testers }:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.8";
=======
{ lib, stdenv, fetchFromGitHub, curl, python3, python3Packages, trurl, testers }:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "curl";
    repo = pname;
    rev = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-KHJMxzHqHW8WbeD6jxyuzZhuHc5x4B7fP/rYAK687ac=";
=======
    hash = "sha256-/Gf7T67LPzVPhjAqTvbLiJOqfKeWvwH/WHelJZTH4ZI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "man" ];
  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [ curl ];
  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
<<<<<<< HEAD
  nativeCheckInputs = [ python3 ];
=======
  nativeCheckInputs = [ python3 python3Packages.packaging ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
