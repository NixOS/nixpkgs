{ stdenv, fetchFromGitHub, autoreconfHook, docbook2x, libarchive, libcap_ng, lzo, zstd, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  pname = "icecream";
  version = "2020-04-15";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = pname;
    rev = "c370c4d701d05e1872d44d1c1642a774a7f25807";
    sha256 = "0ld2ihd39irlk4wshpbw7inmgyl3x0gbkgsy10izcm1wwfc0x2ac";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook docbook2x ];
  buildInputs = [ libarchive libcap_ng lzo zstd docbook_xml_dtd_45 ];

  meta = with stdenv.lib; {
    description = "Distributed compiler with a central scheduler to share build load";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux ++ darwin;
  };
}
