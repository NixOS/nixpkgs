{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cadvisor";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "1652yf2a4ng9z0jq8q6jnzh6svj5nwar9j8q7sssgy36bi03ixqa";
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
