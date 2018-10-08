{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, flex, rdma-core }:

stdenv.mkDerivation rec {
  name = "opensm-${version}";
  version = "3.3.21";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "opensm";
    rev = "${version}";
    sha256 = "0iikw28vslxq3baq9qmmw08yay7l524wciz7dv7km09ylcbx23b7";
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
    homepage = https://www.openfabrics.org/;
    license = licenses.gpl2; # dual licensed as 2-clause BSD
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
