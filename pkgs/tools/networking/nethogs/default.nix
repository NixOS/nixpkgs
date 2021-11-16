{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, libpcap }:

stdenv.mkDerivation rec {
  pname = "nethogs";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "nethogs";
    rev = "v${version}";
    sha256 = "0sn1sdp86akwlm4r1vmkxjjl50c0xaisk91bbz57z7kcsaphxna9";
  };

  patches = [
    # Pull upstream patch for ncurses-6.3 support:
    #  https://github.com/raboof/nethogs/pull/210
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/raboof/nethogs/commit/455daf357da7f394763e5b93b11b3defe1f82ed1.patch";
      sha256 = "0wkp0yr6qg1asgvmsn7blf7rq48sh5k4n3w0nxf5869hxvkhnnzs";
    })
  ];

  buildInputs = [ ncurses libpcap ];

  makeFlags = [ "VERSION=${version}" "nethogs" ];

  installFlags = [ "PREFIX=$(out)" "sbin=$(out)/bin" ];

  meta = with lib; {
    description = "A small 'net top' tool, grouping bandwidth by process";
    longDescription = ''
      NetHogs is a small 'net top' tool. Instead of breaking the traffic down
      per protocol or per subnet, like most tools do, it groups bandwidth by
      process. NetHogs does not rely on a special kernel module to be loaded.
      If there's suddenly a lot of network traffic, you can fire up NetHogs
      and immediately see which PID is causing this. This makes it easy to
      identify programs that have gone wild and are suddenly taking up your
      bandwidth.
    '';
    license = licenses.gpl2Plus;
    homepage = "https://github.com/raboof/nethogs#readme";
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
