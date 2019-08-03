{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, flex, rdma-core }:

stdenv.mkDerivation rec {
  name = "opensm-${version}";
  version = "3.3.22";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "opensm";
    rev = "${version}";
    sha256 = "1nb6zl93ffbgb8z8728j0dxrmvk3pm0i6a1sn7mpn8ki1vkf2y0j";
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
