{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.110";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "1fvvanyzrai41fq98msjwzgwsidxbaly6f6knma6lwmicv4f9svg";
  };

  preBuild = ''
    go generate ./...
  '';

  preFixup = ''
    rm $out/bin/doc
    rm $out/bin/helpgen
  '';

  modSha256 = "0lnk2g5msqhhshh99s32sqd793rdlzmp7vhqdb1fd6qafrrrxm5w";

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}

