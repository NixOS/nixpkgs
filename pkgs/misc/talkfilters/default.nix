{ stdenv, fetchurl }:

let 
  name = "talkfilters";
  version = "2.3.8";
in

stdenv.mkDerivation {
  name = "${name}";

  src = fetchurl {
    url = "http://www.hyperrealm.com/${name}/${name}-${version}.tar.gz";
    sha256 = "19nc5vq4bnkjvhk8srqddzhcs93jyvpm9r6lzjzwc1mgf08yg0a6";
  };

  meta = { 
    description = "Converts English text into text that mimics a stereotyped or humorous dialect";
    homepage = "http://http://www.hyperrealm.com/${name}";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ikervagyok ];
    platforms = with stdenv.lib.platforms; unix;
  };
}

