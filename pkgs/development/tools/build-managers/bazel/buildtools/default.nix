{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bazel-buildtools-unstable-${version}";
  version = "2018-10-11";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "86b40b7fee59cc67d3371d20f10702fe8c6dd808";
    sha256 = "10fzqbafwzv0bvx8aag78gh731k5j9nwlbcflhc5xm5zwhla9cyf";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps.";
    homepage = https://github.com/bazelbuild/buildtools;
    license = licenses.asl20;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.all;
  };
}
