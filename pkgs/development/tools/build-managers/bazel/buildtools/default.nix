{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "bazel-buildtools-${version}";
  version = "0.28.0";
  rev = "d7ccc5507c6c16e04f5e362e558d70b8b179b052";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bazelbuild/buildtools";
    sha256 = "1d8zjgbg77sk27cz9pjz1h6ajwxqmvdzqgwa2jbh6iykibhpadq0";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps.";
    homepage = https://github.com/bazelbuild/buildtools;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog uri-canva ];
    platforms = platforms.all;
  };
}
