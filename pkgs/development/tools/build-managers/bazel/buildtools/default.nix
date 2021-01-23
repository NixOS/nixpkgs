{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "bazel-buildtools";
  version = "3.5.0";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "179k0kwh7i2azkhk8dw7ac50a05q7n3i29pqaf69yw7jrpbf8k85";
  };

  goDeps = ./deps.nix;

  excludedPackages = [ "generatetables" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.buildVersion=${version} -X main.buildScmRevision=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog uri-canva marsam ];
  };
}
