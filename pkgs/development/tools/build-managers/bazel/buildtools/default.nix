{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bazel-buildtools-${version}";
  version = "0.22.0";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "55b64c3d2ddfb57f06477c1d94ef477419c96bd6";
    sha256 = "0n6q8pkgy3vvmwyrxvkmjfbcxc31i31czg2bjdzq7awwrr4fdbwy";
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
