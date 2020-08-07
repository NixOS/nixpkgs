{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "0ys6zyhyi65g0sj15pb6rslgbjgkh73y32gc0yvhfd6xmgzaxpxf";
  };

  vendorSha256 = "1h9p3hrr61hwkhkh4qbw0ld3hd5xi75qm8rwfrpz5z06jba1ll25";

  postInstall = ''
    ln -s $out/bin/packet-cli $out/bin/packet
  '';

  meta = with stdenv.lib; {
    description = "Official Packet CLI";
    homepage = "https://github.com/packethost/packet-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
