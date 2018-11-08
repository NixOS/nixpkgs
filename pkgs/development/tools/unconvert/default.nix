
{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "unconvert-unstable-${version}";
  version = "2018-07-03";
  rev = "1a9a0a0a3594e9363e49545fb6a4e24ac4c68b7b";

  goPackagePath = "github.com/mdempsky/unconvert";

  src = fetchFromGitHub {
    inherit rev;

    owner = "mdempsky";
    repo = "unconvert";
    sha256 = "1ww5qk1cmdis4ig5mb0b0w7nzrf3734s51plmgdxqsr35y88q4p9";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Remove unnecessary type conversions from Go source";
    homepage = https://github.com/mdempsky/unconvert;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
