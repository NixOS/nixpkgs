{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.33.6";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "17zy18s9373f3fp6bqjgj02irzasfv3b6axi84kw7da17mq68vnv";
  };

  vendorSha256 = "0i0n89lal99fqnzva51kp9f7wzqsfmncpshwxhq26kvykp7ji7sw";

  subPackages = [ "cmd/tendermint" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short.";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
