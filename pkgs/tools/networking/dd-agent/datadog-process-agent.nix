{ stdenv, fetchFromGitHub, buildGoPackage  }:

buildGoPackage rec {
  name = "datadog-process-agent-${version}";
  version = "6.10.0";
  owner   = "DataDog";
  repo    = "datadog-process-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "${version}";
    sha256 = "16lr1gp6n0aph8zikk5kmaib9i5b1jbndxlxfi84bd9f8lhvmkhk";
  };

  goDeps = ./datadog-process-agent-deps.nix;
  goPackagePath = "github.com/${owner}/${repo}";

  meta = with stdenv.lib; {
    description = "Live process collector for the DataDog Agent v6";
    homepage    = https://www.datadoghq.com;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ domenkozar rvl ];
  };
}
