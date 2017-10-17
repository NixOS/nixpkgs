{ stdenv, fetchFromGitHub, autoreconfHook, zlib, pkgconfig, libuuid, libcap }:

stdenv.mkDerivation rec{
  version = "1.8.0";
  name = "netdata-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "firehol";
    repo = "netdata";
    sha256 = "1kc6fzzfkfzz3yxy663s7ydq5kn6i6nvaycav8s0sa9k1wkpj3fv";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib libuuid libcap ];

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
