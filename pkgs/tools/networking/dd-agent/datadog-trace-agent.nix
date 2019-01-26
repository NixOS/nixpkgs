{ stdenv, fetchFromGitHub, buildGoPackage  }:

buildGoPackage rec {
  name = "datadog-trace-agent-${version}";
  version = "6.5.0";
  owner   = "DataDog";
  repo    = "datadog-trace-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "6.5.0";
    sha256 = "0xhhcdridilhdwpmr9h3cqg5w4fh87l1jhvzg34k30gdh0g81afw";
  };

  goDeps = ./datadog-trace-agent-deps.nix;
  goPackagePath = "github.com/${owner}/${repo}";

  meta = with stdenv.lib; {
    description = "Live trace collector for the DataDog Agent v6";
    homepage    = https://www.datadoghq.com;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ rob ];
  };
}
