{ stdenv, fetchurl }:

let
  pname = "talkfilters";
  version = "2.3.8";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.hyperrealm.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "19nc5vq4bnkjvhk8srqddzhcs93jyvpm9r6lzjzwc1mgf08yg0a6";
  };

  hardeningDisable = [ "format" ];

  meta = {
    description = "Converts English text into text that mimics a stereotyped or humorous dialect";
    homepage = http://www.hyperrealm.com/talkfilters/talkfilters.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ikervagyok ];
    platforms = with stdenv.lib.platforms; unix;
  };
}

