{ stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  name = "mstpd-svn-${toString version}";
  version = 61;

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/mstpd/code/trunk";
    rev = version;
    sha256 = "0n5vqqqq8hk6iqdz100j9ps4zkz71vyl5qgz5bzjhayab2dyq1fd";
  };

  patches = [ ./fixes.patch ];

  installFlags = [ "DESTDIR=\${out}" ];

  meta = with stdenv.lib; {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = https://sourceforge.net/projects/mstpd/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
