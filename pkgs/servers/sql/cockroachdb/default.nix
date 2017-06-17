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

  buildInputs = [ gcc jemalloc protobuf go which cmake git ];

  patches = [./gopath.patch];

  postUnpack = ''
    mkdir src pkg
    chmod -R u+w src
    chmod -R u+w cockroach-${version}-src
    mv cockroach-${version}-src src
    chmod -R u+w src/cockroach-${version}-src
  '';
  sourceRoot = "./src/cockroach-${version}-src";
  dontMakeSourcesWritable = true;

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
