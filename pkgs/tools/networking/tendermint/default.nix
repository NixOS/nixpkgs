{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.33.8";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dcr60gmbkb6833n49mjmlr082ahlv7alaqycl8g3d4f93kdm5c3";
  };

  vendorSha256 = "0i0n89lal99fqnzva51kp9f7wzqsfmncpshwxhq26kvykp7ji7sw";

  doCheck = false;

  subPackages = [ "cmd/tendermint" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
