{ fetchurl }:

let version = "1.1.0"; in

fetchurl {
  url = "http://semicomplete.com/files/logstash/logstash-${version}-monolithic.jar";

  name = "logstash-${version}.jar";

  sha256 = "03s9g2appsmdg973212dl37ldws36fgsvxi9w1lxbvmmclc4k7vc";
}
