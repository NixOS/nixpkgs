{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.32.2";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "d70135ec71979e7588c649c80f2acea65346a99a";
    sha256 = "062lzc1c96nwg22ql10mwjkxhq68lyak7s0id5y4f9mmj6d4rd69";
  };

  modSha256 = "0hl8ly2qx0fv9diipqkcrlaz3ncsb2h81i0ccf5gn9cmyl37x0yk";

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short.";
    homepage = https://tendermint.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
