{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  pname = "bazel-buildtools";
  version = "0.29.0";
  rev = "5bcc31df55ec1de770cb52887f2e989e7068301f";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/bazelbuild/buildtools";
    sha256 = "0p2kgyawh3l46h7dzglqh9c7i16zr5mhmqlhy7qvr4skwif1l089";
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
