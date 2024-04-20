{ lib, stdenv, fetchFromGitHub, autoconf, automake, cmake, libtool, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "aerospike-server";
  version = "7.0.0.7";

  src = fetchFromGitHub {
    owner = "aerospike";
    repo = "aerospike-server";
    rev = version;
    hash = "sha256-WAdN0Kk55Y3rhth1tiAZb9xIb0tF3YVfP+BXGRRY3lI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoconf automake cmake libtool ];
  buildInputs = [ openssl zlib ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    patchShebangs build/gen_version
    substituteInPlace build/gen_version --replace 'git describe' 'echo ${version}'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/Linux-x86_64/bin/asd $out/bin/asd
  '';

  meta = with lib; {
    description = "Flash-optimized, in-memory, NoSQL database";
    mainProgram = "asd";
    homepage = "https://aerospike.com/";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kalbasit ];
  };
}
