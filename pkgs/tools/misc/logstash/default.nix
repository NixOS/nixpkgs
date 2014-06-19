{ fetchurl }:

let version = "1.3.3"; in

fetchurl {
  url = "https://download.elasticsearch.org/logstash/logstash/logstash-${version}-flatjar.jar";

  name = "logstash-${version}-flatjar.jar";

  sha256 = "a83503bd2aa32e1554b98f812d0b411fbc5f7b6b21cebb48b7d344474f2dfc6d";
}
