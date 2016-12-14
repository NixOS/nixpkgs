{ stdenv, fetchgit, autoconf, automake, perl, libX11 }:

stdenv.mkDerivation rec {
  name = "ffcast-${version}";
  version = "2.5.0";
  rev = "7c3bf681e7ca9b242e55dbf0c07856ed994d94e9";

  src = fetchgit {
    url = https://github.com/lolilolicon/FFcast;
    sha256 = "1s1y6rqjq126jvdzc75wz20szisbz8h8fkphlwxcxzl9xll17akj";
  };

  buildInputs = [ autoconf automake perl libX11 ];

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [ "--enable-xrectsel" ];

  postBuild = ''
    make DESTDIR="$out" install
  '';

  meta = with stdenv.lib; {
    description = "Run commands on rectangular screen regions";
    homepage = https://github.com/lolilolicon/FFcast;
    license = licenses.gpl3;
    maintainers = [ maintainers.guyonvarch ];
    platforms = platforms.linux;
  };
}
