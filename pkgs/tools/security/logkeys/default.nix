{ stdenv, fetchgit, autoconf, automake, which, procps, kbd }:

stdenv.mkDerivation rec {
  name = "logkeys-${version}";
  version = "2017-10-10";

  src = fetchgit {
    url = https://github.com/kernc/logkeys;
    rev = "5c368327a2cd818efaed4794633c260b90b87abf";
    sha256 = "0akj7j775y9c0p53zq5v12jk3fy030fpdvn5m1x9w4rdj47vxdpg";
  };

  buildInputs = [ autoconf automake which procps kbd ];

  postPatch = ''
    substituteInPlace src/Makefile.am --replace 'root' '$(id -u)'
    substituteInPlace configure.ac --replace '/dev/input' '/tmp'
    sed -i '/chmod u+s/d' src/Makefile.am
 '';

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "A GNU/Linux keylogger that works!";
    license = licenses.gpl3;
    homepage = https://github.com/kernc/logkeys;
    maintainers = with maintainers; [mikoim offline];
    platforms = platforms.linux;
  };
}
