{ stdenv, fetchsvn, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "spawn-fcgi-${version}";
  version = "1.6.3";

  src = fetchsvn {
    url = "svn://svn.lighttpd.net/spawn-fcgi/tags/spawn-fcgi-${version}";
    sha256 = "06f0zw3rja42d9vg8j68nqkm3mn5pfzzhwfadpvs4aidh6kz9p42";
  };

  buildInputs = [ automake autoconf ];

  patches = [ ./show_version.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage    = "http://redmine.lighttpd.net/projects/spawn-fcgi";
    description = "Provides an interface to external programs that support the FastCGI interface";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan ];
  };
}
