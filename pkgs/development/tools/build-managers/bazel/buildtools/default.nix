{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "bazel-buildtools-unstable-${version}";
  version = "2019-06-21";
  rev = "baa9c57c396019f0b7272b95d66f8e2681ed7d2a";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bazelbuild/buildtools";
    sha256 = "0xwsm05y8xbxpyzzgcxhznvzxb6vpqw8qnsil1g6crmaa2jjfpw6";
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
