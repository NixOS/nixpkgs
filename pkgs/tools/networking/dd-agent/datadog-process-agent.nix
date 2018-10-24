{ stdenv, fetchFromGitHub, buildGoPackage  }:

buildGoPackage rec {
  name = "datadog-process-agent-${version}";
  # NOTE: this is 6.5.0 + https://github.com/DataDog/datadog-process-agent/pull/185
  version = "6.5.0";
  owner   = "DataDog";
  repo    = "datadog-process-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "bd96c99c97e8639fd3ea72e61a492c0a74686abe";
    sha256 = "0afdf344256jivzhdv3k9n9i4aik1yr805dnrc2i3d4di9w8vg8c";
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
