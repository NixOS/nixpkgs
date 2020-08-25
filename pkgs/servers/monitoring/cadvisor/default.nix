{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cadvisor";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "15njzwvsl7jc2hgxlpsksmn7md3bqpavzaskfdlmzxnxp3biw3cj";
  };

  goPackagePath = "github.com/google/cadvisor";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/google/cadvisor/version.Version=${version}" ];

  meta = with stdenv.lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
