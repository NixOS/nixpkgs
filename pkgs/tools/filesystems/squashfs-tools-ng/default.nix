{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkgconfig
, lz4, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "0.8";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "1km18qm9kgmm39aj9yq2aaq99708nmj9cpa9lqf5bp1y617bhh7y";
  };

  nativeBuildInputs = [ doxygen graphviz pkgconfig perl ];
  buildInputs = [ zlib xz lz4 zstd ];

  meta = with lib; {
    homepage = https://github.com/AgentD/squashfs-tools-ng;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
