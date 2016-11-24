{ stdenv, fetchFromGitHub, autoreconfHook, zlib, pkgconfig, libuuid }:

stdenv.mkDerivation rec{
  version = "1.4.0";
  name = "netdata-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "firehol";
    repo = "netdata";
    sha256 = "1wknxci2baj6f7rl8z8j7haaz122jmbb74aw7i3xbj2y61cs58n8";
  };

  buildInputs = [ autoreconfHook zlib pkgconfig libuuid ];

  # Allow UI to load when running as non-root
  patches = [ ./web_access.patch ];

  # Build will fail trying to create /var/{cache,lib,log}/netdata without this
  postPatch = ''
   sed -i '/dist_.*_DATA = \.keep/d' src/Makefile.am
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  # App fails on runtime if the default config file is not detected
  # The upstream installer does prepare an empty file too
  postInstall = ''
    touch $out/etc/netdata/netdata.conf
  '';

  meta = with stdenv.lib; {
    description = "Real-time performance monitoring tool";
    homepage = http://netdata.firehol.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
