{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.102";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "181j248i8j9g7kz5krg0bkbxkvmcwpz2vlknii5q3dy7yhgg19h3";
  };

  preBuild = ''
    go generate ./...
  '';

  preFixup = ''
    rm $out/bin/doc
    rm $out/bin/helpgen
  '';

  modSha256 = "1mqkc7hnavvpbqar9f1d2vnm47p4car9abnk2ikyf27jr5glwmsd";

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}

