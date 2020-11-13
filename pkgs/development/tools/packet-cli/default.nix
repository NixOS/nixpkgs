{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "089fcn7yslijjivyvwl85j32gfwif8aazqdhm6hi676lz80ssppp";
  };

  vendorSha256 = "1p3v4pzw9hc1iviv1zghw9imbd23nlp24dpa8hf0w8a03jvpy96x";

  postInstall = ''
    ln -s $out/bin/packet-cli $out/bin/packet
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official Packet CLI";
    homepage = "https://github.com/packethost/packet-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
