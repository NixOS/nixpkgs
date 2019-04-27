{ stdenv, fetchFromGitHub, buildGoPackage  }:

buildGoPackage rec {
  name = "datadog-process-agent-${version}";
  version = "6.11.0";
  owner   = "DataDog";
  repo    = "datadog-process-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "${version}";
    sha256 = "1max3gp1isb30fjy55bkp9dsd8al31a968pmnr1h8wg2pycvgyif";
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
