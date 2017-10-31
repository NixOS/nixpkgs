{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "filebench-${version}";
  version = "1.4.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/filebench/${name}.tar.gz";
    sha256 = "0y06f9mp4xry6j1jamqprzn963l0krqayv14yv66pm51hdh53ld1";
  };

  meta = with stdenv.lib; {
    description = "File system and storage benchmark that can generate both micro and macro workloads";
    homepage = https://sourceforge.net/projects/filebench/;
    license = licenses.cddl;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
