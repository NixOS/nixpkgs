{ fetchurl }:

let version = "1.2.1"; in

fetchurl {
  url = "https://logstash.objects.dreamhost.com/release/logstash-${version}-flatjar.jar";

  name = "logstash-${version}.jar";

  sha256 = "08zfhq6klhkqapqnyzbdikgryd8bj2fp0wdb5d6dawdan5psbf6h";
}
