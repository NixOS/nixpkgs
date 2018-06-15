{ stdenv, fetchgit, autoconf, automake, libtool, bison, flex, rdma-core }:

stdenv.mkDerivation rec {
  name = "opensm-${version}";
  version = "3.3.20";

  src = fetchgit {
    url = git://git.openfabrics.org/~halr/opensm.git;
    rev = name;
    sha256 = "1hlrn5z32yd4w8bj4z6bsfv84pk178s4rnppbabyjqv1rg3c58wl";
  };

  nativeBuildInputs = [ autoconf automake libtool bison flex ];

  buildInputs = [ rdma-core ];

  preConfigure = "bash ./autogen.sh";

  meta = with stdenv.lib; {
    description = "Infiniband subnet manager";
    homepage = https://www.openfabrics.org/;
    license = licenses.gpl2; # dual licensed as 2-clause BSD
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
