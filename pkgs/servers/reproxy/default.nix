{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reproxy";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "umputun";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ac4fOOMht2WGlrXLN95NEIA8ivqghhVuxHnBumvajx0=";
=======
    hash = "sha256-3kpGeG60WSpcIqVLw437gkDT8XLsDyhGL8/sEnhTgBw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Requires network access
    substituteInPlace app/main_test.go \
      --replace "Test_Main" "Skip_Main"
    substituteInPlace app/proxy/proxy_test.go \
      --replace "TestHttp_matchHandler" "SkipHttp_matchHandler"
  '' + lib.optionalString stdenv.isDarwin ''
    # Fails on Darwin.
    # https://github.com/umputun/reproxy/issues/77
    substituteInPlace app/discovery/provider/file_test.go \
      --replace "TestFile_Events" "SkipFile_Events" \
      --replace "TestFile_Events_BusyListener" "SkipFile_Events_BusyListener"
  '';

<<<<<<< HEAD
  vendorHash = null;
=======
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w" "-X main.revision=${version}"
  ];

  installPhase = ''
    install -Dm755 $GOPATH/bin/app $out/bin/reproxy
  '';

  meta = with lib; {
    description = "Simple edge server / reverse proxy";
    homepage = "https://reproxy.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
