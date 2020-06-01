{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.32.12";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d3q5d49pzh86brrwp4kfsxs0n9zdmcnkminarg3wl9w97qrjsr6";
  };

  vendorSha256 = "1vhd3s6yxfhirgipxcy0rh8sk55cdzirr8n8r31sijgyak92mq0l";

  meta = with stdenv.lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short.";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}