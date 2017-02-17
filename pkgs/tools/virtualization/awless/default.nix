{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "awless-${version}";
  version = "0.0.13";
  rev = "${version}";

  goPackagePath = "github.com/wallix/awless";

  src = fetchFromGitHub {
    inherit rev;
    owner = "wallix";
    repo = "awless";
    sha256 = "045n4r2mk40pjggsfcjlxni6q4arybs9x9raghqb9n8dyfg9v5kv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/wallix/awless/;
    description = "A Mighty CLI for AWS";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
