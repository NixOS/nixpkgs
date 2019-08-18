{ stdenv, fetchFromGitHub, buildGoPackage  }:

buildGoPackage rec {
  pname = "datadog-process-agent";
  version = "6.11.1";
  owner   = "DataDog";
  repo    = "datadog-process-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "${version}";
    sha256 = "0fc2flm0pa44mjxvn4fan0mkvg9yyg27w68xdgrnpdifj99kxxjf";
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
