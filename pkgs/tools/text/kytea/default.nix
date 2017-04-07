{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name    = "kytea-${version}";
  version = "0.4.7";

  src = fetchurl {
    url    = "http://www.phontron.com/kytea/download/${name}.tar.gz";
    sha256 = "0ilzzwn5vpvm65bnbyb9f5rxyxy3jmbafw9w0lgl5iad1ka36jjk";
  };

  meta = with stdenv.lib; {
    homepage = http://www.phontron.com/kytea/;
    description = "General toolkit developed for analyzing text";

    longDescription = ''
      A general toolkit developed for analyzing text, with a focus on Japanese, 
      Chinese and other languages requiring word or morpheme segmentation.
    '';

    license = licenses.asl20;

    maintainers = with maintainers; [ ericsagnes ndowens ];
    platforms = platforms.linux;
  };

}
