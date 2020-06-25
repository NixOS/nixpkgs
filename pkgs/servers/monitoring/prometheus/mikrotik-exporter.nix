{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "mikrotik-exporter-unstable";
  version = "2020-02-10";

  src = fetchFromGitHub {
    owner = "nshttpd";
    repo = "mikrotik-exporter";
    sha256 = "193zh06rqp9ybsnkxwmv7l4p2h2xisw4f01jjirshsb784j44bh6";
    rev = "3b33400d24abcfdc07dc31c15ca5ba7b82de444f";
  };

  vendorSha256 = "0i5x4d3ra0s41knmybbg8gnjxgraxkid6y3gfkjwa65xcbp7hr7q";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) mikrotik; };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Prometheus MikroTik device(s) exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmilata ];
  };
}
