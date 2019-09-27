{ stdenv, fetchurl, cmake, makeWrapper, python
, boost, lzma
, withGog ? false, unar ? null }:

stdenv.mkDerivation rec {
  name = "innoextract-1.8";

  src = fetchurl {
    url = "http://constexpr.org/innoextract/files/${name}.tar.gz";
    sha256 = "0saj50n8ds85shygy4mq1h6s99510r9wgjjdll4dmvhra4lzcy2y";
  };

  buildInputs = [ python lzma boost ];

  nativeBuildInputs = [ cmake makeWrapper ];

  enableParallelBuilding = true;

  # we need unar to for multi-archive extraction
  postFixup = stdenv.lib.optionalString withGog ''
    wrapProgram $out/bin/innoextract \
      --prefix PATH : ${stdenv.lib.makeBinPath [ unar ]}
  '';

  meta = with stdenv.lib; {
    description = "A tool to unpack installers created by Inno Setup";
    homepage = http://constexpr.org/innoextract/;
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
