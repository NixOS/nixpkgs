{stdenv, fetchurl, aterm, getopt, pkgconfig}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.4";
  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/meta-environment/sdf2-bundle-2.4pre212034-2nspl1xc/sdf2-bundle-2.4.tar.gz;
    md5 = "00107bef17d3fb8486575f8974fb384b";
  };

  buildInputs = [aterm pkgconfig];
  propagatedBuildInputs = [getopt];
}
