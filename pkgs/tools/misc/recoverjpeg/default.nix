{ stdenv, fetchurl, makeWrapper, python2, exif, imagemagick }:

stdenv.mkDerivation rec {
  name = "recoverjpeg-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "https://www.rfc1149.net/download/recoverjpeg/${name}.tar.gz";
    sha256 = "00zi23l4nq9nfjg1zzbpsfxf1s47r5w713aws90w13fd19jqn0rj";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python2 ];

  postFixup = ''
    wrapProgram $out/bin/sort-pictures \
      --prefix PATH : ${stdenv.lib.makeBinPath [ exif imagemagick ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://rfc1149.net/devel/recoverjpeg.html;
    description = "Recover lost JPEGs and MOV files on a bogus memory card or disk";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
