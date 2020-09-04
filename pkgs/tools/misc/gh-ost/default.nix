{ stdenv, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/github/gh-ost";
  version = "1.1.0";
  sha256 = "0laj5nmf10qn01mqn0flipmhankgvrcfbdl3bc76wa14qkkg722m";

in
buildGoPackage ({
    pname = "gh-ost";
    inherit version;
    inherit goPackagePath;

    src = fetchFromGitHub {
      owner = "github";
      repo  = "gh-ost";
      rev   = "v${version}";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      description = "Triggerless online schema migration solution for MySQL";
      homepage = "https://github.com/github/gh-ost";
      license = licenses.mit;
    };
})

