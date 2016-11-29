{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "packetbeat-${version}";
  version = "5.0.2";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/beats/packetbeat/${name}-linux-x86_64.tar.gz";
    sha256 = "0x4n1250nbaadkjm1wr2iw1fd2ri5ipbxll6lczmqh8ssbykzb27";
  };

  dontBuild = true;
  doCheck = false;

  # need to patch interpreter to be able to run on NixOS
  patchPhase = ''
    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) packetbeat
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp packetbeat $out/bin/
  '';

  meta = {
    description = "Network packet analyzer that ships data to Elasticsearch";
    longDescription = ''
      Packetbeat is an open source network packet analyzer that ships the data to Elasticsearch.

      Think of it like a distributed real-time Wireshark with a lot more analytics features.
      The Packetbeat shippers sniff the traffic between your application processes, parse on the fly protocols like HTTP, MySQL, PostgreSQL, Redis or Thrift and correlate the messages into transactions.
    '';
    homepage = https://www.elastic.co/products/beats;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
