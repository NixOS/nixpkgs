{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, flex, rdma-core }:

stdenv.mkDerivation rec {
  pname = "opensm";
  version = "3.3.23";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "opensm";
    rev = version;
    sha256 = "0r0nw7b2711ca6mrj19ymg97x862hdxv54fhhm4kiqvdh6n75y0s";
  };

  nativeBuildInputs = [ autoconf automake libtool bison flex ];

  buildInputs = [ rdma-core ];

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Infiniband subnet manager";
    homepage = "https://www.openfabrics.org/";
    license = licenses.gpl2; # dual licensed as 2-clause BSD
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
