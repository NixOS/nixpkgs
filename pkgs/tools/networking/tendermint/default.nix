{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.32.11";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "17p7khfiv5aflpl4imbqp8v7gignd6v6a7g80xlnzgix5ismh84l";
  };

  modSha256 = "1sdjzj52gkqk51ml29hijzv64clmi38km5z7j7paf28dla2brfxq";

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short.";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
