{ stdenv, fetchurl, cmake
, boost, eigen2, lua, luabind, mesa, SDL }:

stdenv.mkDerivation rec {
  name = "soi-${version}";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/soi/Spheres%20of%20Influence-${version}-Source.tar.bz2";
    name = "${name}.tar.bz2";
    sha256 = "03c3wnvhd42qh8mi68lybf8nv6wzlm1nx16d6pdcn2jzgx1j2lzd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost lua luabind mesa SDL ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen2}/include/eigen2"
  ];

  meta = with stdenv.lib; {
    description = "A physics-based puzzle game";
    maintainers = with maintainers; [ raskin nckx ];
    platforms = platforms.linux;
    license = licenses.free;
    broken = true;
    downloadPage = http://sourceforge.net/projects/soi/files/;
  };
}
