{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name    = "kytea-${version}";
  version = "0.4.7";

  src = fetchurl {
    url    = "http://www.phontron.com/kytea/download/kytea-0.4.6.tar.gz";
    sha256 = "0n6d88j0qda4dmy6mcj0cyin46n05m5phvjiah9i4ip54h8vs9s3";
  };

  meta = with stdenv.lib; {
    homepage = http://www.phontron.com/kytea/;
    description = "General toolkit developed for analyzing text";

    longDescription = ''
      A general toolkit developed for analyzing text, with a focus on Japanese, 
      Chinese and other languages requiring word or morpheme segmentation.
    '';

    license = licenses.asl20;

    maintainers = [ maintainers.ericsagnes ];
    platforms = platforms.linux;
  };

}
