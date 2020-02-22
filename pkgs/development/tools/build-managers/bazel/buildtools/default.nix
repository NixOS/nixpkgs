{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "bazel-buildtools";
  version = "1.0.0";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "1rgz1bpg2db6z4q04z061h5b9qjk8padi71xyjcwqfchwqpl7hiv";
  };

  goDeps = ./deps.nix;

  excludedPackages = [ "generatetables" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.buildVersion=${version} -X main.buildScmRevision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps.";
    homepage = https://github.com/bazelbuild/buildtools;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog uri-canva marsam ];
    platforms = platforms.all;
  };
}
