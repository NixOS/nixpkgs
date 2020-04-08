{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cadvisor";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "12hk2l82i7hawzbvj6imcfwn6v8pcfv0dbjfn259yi4b0jrlx6l8";
  };

  goPackagePath = "github.com/google/cadvisor";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/google/cadvisor/version.Version=${version}" ];

  meta = with stdenv.lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = https://github.com/google/cadvisor;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
