{ stdenv, fetchFromGitHub, gcc, jemalloc, protobuf, go, which, cmake, git }:

stdenv.mkDerivation rec {
  name = "cockroach-${version}";
  version = "v1.0.2";

  src = fetchFromGitHub {
    name = "cockroach-${version}-src";
    owner = "cockroachdb";
    repo = "cockroach";
    rev = "refs/tags/" + version;
    sha256 = "1r5dq2q5d1nsvwq7g58ril3976h8p1hclb9sgx02sph9ca6drjak";
    fetchSubmodules = true;
  };

  buildRev = "9e3606bd2863ce7a460fd0c842414673d62f0533";

  buildInputs = [ gcc jemalloc protobuf go which cmake git ];

  patches = [./nix.patch];

  dontMakeSourcesWritable = true;
  sourceRoot = "./src/github.com/cockroachdb/cockroach";
  postUnpack = ''
    mkdir -p src/github.com/cockroachdb/ pkg
    chmod -R u+w src
    chmod -R u+w cockroach-${version}-src
    mv cockroach-${version}-src src/github.com/cockroachdb/cockroach
  '';

  buildPhase = ''
    export GOPATH=$NIX_BUILD_TOP
    make build
  '';
  dontUseCmakeConfigure = true;

  meta = with stdenv.lib; {
    homepage = https://www.cockroachlabs.com;
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.rushmorem maintainers.nyarly ];
  };
}
