{ stdenv, fetchFromGitHub, autoreconfHook, zlib, pkgconfig, libuuid }:

stdenv.mkDerivation rec{
  version = "1.9.0";
  name = "netdata-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "firehol";
    repo = "netdata";
    sha256 = "1vy0jz5lxw63b830l9jgf1qqhp41gzapyhdr5k1gwg3zghvlg10w";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib libuuid ];

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
