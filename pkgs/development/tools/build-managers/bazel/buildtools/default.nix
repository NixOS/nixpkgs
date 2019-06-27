{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bazel-buildtools-${version}";
  version = "0.26.0";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "${version}";
    sha256 = "12dhhsnwp1r5w8x593d5fpgdlyikmnppa3mfkq1ynx3ax6szybcf";
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
