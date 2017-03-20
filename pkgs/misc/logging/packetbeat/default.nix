{ stdenv, fetchFromGitHub, buildGoPackage, libpcap }:

buildGoPackage rec {
  name = "packetbeat-${version}";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    rev = "v${version}";
    sha256 = "19hkq19xpi3c9y5g1yq77sm2d5vzybn6mxxf0s5l6sw4l98aak5q";
  };

  goPackagePath = "github.com/elastic/beats";

  subPackages = [ "packetbeat" ];

  buildInputs = [ libpcap ];

  meta = with stdenv.lib; {
    description = "Network packet analyzer that ships data to Elasticsearch";
    longDescription = ''
      Packetbeat is an open source network packet analyzer that ships the
      data to Elasticsearch.

      Think of it like a distributed real-time Wireshark with a lot more
      analytics features. The Packetbeat shippers sniff the traffic between
      your application processes, parse on the fly protocols like HTTP, MySQL,
      PostgreSQL, Redis or Thrift and correlate the messages into transactions.
    '';
    homepage = https://www.elastic.co/products/beats;
    license = licenses.asl20;
    maintainers = [ maintainers.fadenb ];
    platforms = platforms.linux;
  };
}
