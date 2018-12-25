{ stdenv, fetchFromGitHub, autoconf, automake, libtool, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "aerospike-server-${version}";
  version = "4.2.0.4";

  src = fetchFromGitHub {
    owner = "aerospike";
    repo = "aerospike-server";
    rev = version;
    sha256 = "1vqi3xir4l57v62q1ns3713vajxffs6crss8fpvbcs57p7ygx3s7";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ openssl zlib ];

  preBuild = ''
    patchShebangs build/gen_version
    substituteInPlace build/gen_version --replace 'git describe' 'echo ${version}'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/udf
    cp      target/Linux-x86_64/bin/asd $out/bin/asd
    cp -dpR modules/lua-core/src        $out/share/udf/lua
  '';

  meta = with stdenv.lib; {
    description = "Flash-optimized, in-memory, NoSQL database";
    homepage = http://aerospike.com/;
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kalbasit ];
  };
}
