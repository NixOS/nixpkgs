{ buildGoModule
, fetchFromGitHub
, stdenv
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "03713b4bkhcz61maz0r5mkd36kv3rq8rji3qcpi9zf5bkkjs1yzb";
  };

  vendorSha256 = if stdenv.isDarwin
    then "0anw3l6pq8yys2g2607ndhklb9m1i9krgjrw4wb99igavjzp3wpj"
    else "04h463d2d7g6wqp5mzkqlszwzdbq0pix6j7n2s9s80lwg7nh8k3h";

  subPackages = [ "cmd/otelcontribcol" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    description = "OpenTelemetry Collector";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
  };
}
