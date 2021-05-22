{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reproxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8veGMiRT59oLcMUxERI+2uRQVvbiuXTbrBi1GqoPe0M=";
  };

  postPatch = ''
    # Requires network access
    substituteInPlace app/main_test.go \
      --replace "Test_Main" "Skip_Main"

    # Fails on Darwin.
    # https://github.com/umputun/reproxy/issues/77
    substituteInPlace app/discovery/provider/file_test.go \
      --replace "TestFile_Events" "SkipFile_Events" \
      --replace "TestFile_Events_BusyListener" "SkipFile_Events_BusyListener"
  '';

  vendorSha256 = null;

  buildFlagsArray = [
    "-ldflags=-s -w -X main.revision=${version}"
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
