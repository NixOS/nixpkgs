{ stdenv, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/github/gh-ost";
  version = "1.0.47";
  sha256 = "0yyhkqis4j2cl6w2drrjxdy5j8x9zp4j89gsny6w4ql8gm5qgvvk";

in
buildGoPackage ({
    name = "gh-ost-${version}";
    inherit goPackagePath;

    src = fetchFromGitHub {
      owner = "github";
      repo  = "gh-ost";
      rev   = "v${version}";
      inherit sha256;
    };

    meta = with stdenv.lib; {
      description = "Triggerless online schema migration solution for MySQL";
      homepage = https://github.com/github/gh-ost;
      license = licenses.mit;
      platforms = platforms.linux;
    };
})

