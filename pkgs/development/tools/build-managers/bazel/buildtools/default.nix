{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bazel-buildtools-unstable-${version}";
  version = "2018-05-24";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "588d90030bc8054b550967aa45a8a8d170deba0b";
    sha256 = "18q1z138545kh4s5k0jcqwhpzc1w7il4x00l7yzv9wq8bg1vn1rv";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "This derivation contains developer tools for working with Google's bazel buildtool.";
    homepage = https://github.com/bazelbuild/buildtools;
    license = licenses.asl20;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.all;
  };
}
