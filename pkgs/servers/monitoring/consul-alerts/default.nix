{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-alerts-${version}";
  version = "0.5.0";
  rev = "v${version}";

  goPackagePath = "github.com/AcalephStorage/consul-alerts";

  src = fetchFromGitHub {
    inherit rev;
    owner = "AcalephStorage";
    repo = "consul-alerts";
    sha256 = "0dff2cpk3lkgjsh97rvlrpacpka0kwm29691diyvj7lb9ydzlx3r";
  };

  extraSrcs = [
    {
      goPackagePath = "github.com/aws/aws-sdk-go";
      src = fetchFromGitHub {
        owner = "aws";
        repo = "aws-sdk-go";
        rev = "v1.10.4";
        sha256 = "0jnikx2hjngh6ndv4i60w5nwx2hgnrx0i2av99s8hj8yfkxi3qkb";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/hashstructure";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "hashstructure";
        rev = "2bca23e0e452137f789efbc8610126fd8b94f73b";
        sha256 = "0vpacsls26474wya360fjhzi6l4y8s8s251c4szvqxh17n5f5gk1";
      };
    }
    {
      goPackagePath = "github.com/imdario/mergo";
      src = fetchFromGitHub {
        owner = "imdario";
        repo = "mergo";
        rev = "0.2.2";
        sha256 = "1qnd5lsvsf0p9g1ssd0cy8g6qdkq439a9lqnir374nj7hkx4nl7p";
      };
    }
  ];
}
