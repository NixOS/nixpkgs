{ stdenv, buildGoPackage, fetchFromGitHub, gcc, jemalloc, protobuf }:

buildGoPackage rec {
  name = "cockroach-${version}";
  version = "v1.0.2";

  goPackagePath = "github.com/cockroachdb/cockroach";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    name = "cockroach-${version}-src";
    owner = "cockroachdb";
    repo = "cockroach";
    rev = "refs/tags/" + version;
    sha256 = "1r5dq2q5d1nsvwq7g58ril3976h8p1hclb9sgx02sph9ca6drjak";
    fetchSubmodules = true;
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/cockroachdb/cockroach/build.tag=${version}
  '';

  buildInputs = [ gcc jemalloc protobuf ];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.rushmorem maintainers.nyarly ];
  };
}
