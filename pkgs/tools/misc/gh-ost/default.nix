{ stdenv, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/github/gh-ost";
  version = "1.0.49";
  sha256 = "0mncjhmv25wnhgjkn9gwkz2gzh0v6954w47ql7fs2iqr9al111dq";

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

