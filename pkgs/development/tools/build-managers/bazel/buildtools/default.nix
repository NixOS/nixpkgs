{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "bazel-buildtools";
  version = "3.3.0";

  goPackagePath = "github.com/bazelbuild/buildtools";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "0g411gjbm02qd5b50iy6kk81kx2n5zw5x1m6i6g7nrmh38p3pn9k";
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
