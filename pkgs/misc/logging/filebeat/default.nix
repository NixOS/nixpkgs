{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "filebeat-${version}";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    rev = "v${version}";
    sha256 = "19hkq19xpi3c9y5g1yq77sm2d5vzybn6mxxf0s5l6sw4l98aak5q";
  };

  goPackagePath = "github.com/elastic/beats";

  subPackages = [ "filebeat" ];

  meta = with stdenv.lib; {
    description = "Lightweight shipper for logfiles";
    homepage = https://www.elastic.co/products/beats;
    license = licenses.asl20;
    maintainers = [ maintainers.fadenb ];
    platforms = platforms.linux;
  };
}
