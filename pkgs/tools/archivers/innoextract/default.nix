{ lib, stdenv, fetchurl, cmake, makeWrapper, python
, boost, lzma
, withGog ? false, unar ? null }:

stdenv.mkDerivation rec {
  name = "innoextract-1.9";

  src = fetchurl {
    url = "https://constexpr.org/innoextract/files/${name}.tar.gz";
    sha256 = "09l1z1nbl6ijqqwszdwch9mqr54qb7df0wp2sd77v17dq6gsci33";
  };

  buildInputs = [ python lzma boost ];

  nativeBuildInputs = [ cmake makeWrapper ];

  # we need unar to for multi-archive extraction
  postFixup = stdenv.lib.optionalString withGog ''
    wrapProgram $out/bin/innoextract \
      --prefix PATH : ${stdenv.lib.makeBinPath [ unar ]}
  '';

  meta = with lib; {
    description = "A tool to unpack installers created by Inno Setup";
    homepage = "https://constexpr.org/innoextract/";
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
