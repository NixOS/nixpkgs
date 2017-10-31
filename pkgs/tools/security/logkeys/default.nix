{ stdenv, fetchgit, which, procps, kbd }:

stdenv.mkDerivation rec {
  name = "logkeys-${version}";
  version = "2015-11-10";

  src = fetchgit {
    url = https://github.com/kernc/logkeys;
    rev = "78321c6e70f61c1e7e672fa82daa664017c9e69d";
    sha256 = "1b1fa1rblyfsg6avqyls03y0rq0favipn5fha770rsirzg4r637q";
  };

  buildInputs = [ which procps kbd ];

  postPatch = ''
    substituteInPlace src/Makefile.in --replace 'root' '$(id -u)'
    substituteInPlace configure --replace '/dev/input' '/tmp'
    sed -i '/chmod u+s/d' src/Makefile.in
 '';

  meta = with stdenv.lib; {
    description = "A GNU/Linux keylogger that works!";
    license = licenses.gpl3;
    homepage = https://github.com/kernc/logkeys;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
