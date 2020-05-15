{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "bazel-buildtools";
  version = "2.2.1";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "165jvn7r7bxivb8mpvp6dni5a5ns9a3vm6y5clyxdbjhfkll8wra";
  };

  goDeps = ./deps.nix;

  excludedPackages = [ "generatetables" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.buildVersion=${version} -X main.buildScmRevision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps.";
    homepage = "https://github.com/bazelbuild/buildtools";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog uri-canva marsam ];
    platforms = platforms.all;
  };
}
