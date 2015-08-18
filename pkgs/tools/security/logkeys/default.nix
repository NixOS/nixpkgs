{ stdenv, fetchgit, which, procps, kbd }:

stdenv.mkDerivation rec {
  name = "logkeys-${version}";
  version = "5ef6b0dcb9e3";

  src = fetchgit {
    url = https://github.com/kernc/logkeys;
    rev = "5ef6b0dcb9e38e6137ad1579d624ec12107c56c3";
    sha256 = "02p0l92l0fq069g31ks6xbqavzxa9njj9460vw2jsa7livcn2z9d";
  };

  buildInputs = [ which procps kbd ];

  postPatch = ''
    substituteInPlace src/Makefile.in --replace 'root' '$(id -u)'
    substituteInPlace configure --replace '/dev/input' '/tmp'
 '';

  meta = with stdenv.lib; {
    description = "A GNU/Linux keylogger that works!";
    license = licenses.gpl3;
    homepage = https://github.com/kernc/logkeys;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
