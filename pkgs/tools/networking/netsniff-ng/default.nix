{ stdenv, fetchFromGitHub, bison, flex, geoip, geolite-legacy, libcli, libnet
, libnetfilter_conntrack, libnl, libpcap, libsodium, liburcu, ncurses, perl
, pkgconfig, zlib }:

let version = "0.5.9-88-ge5570a8"; in
stdenv.mkDerivation {
  name = "netsniff-ng-${version}";

  # Upstream recommends and supports git
  src = fetchFromGitHub rec {
    repo = "netsniff-ng";
    owner = repo;
    rev = "e5570a84d16022dda6de7d5a55f7b7bd53d4a8de";
    sha256 = "0w1l5a49xcwrp78djcs8d4737ndji9jp7x0v5q5yl5jfg0cdgmzc";
  };

  buildInputs = [ bison flex geoip geolite-legacy libcli libnet libnl
    libnetfilter_conntrack libpcap libsodium liburcu ncurses perl
    pkgconfig zlib ];

  # ./configure is not autoGNU but some home-brewn magic
  configurePhase = ''
    patchShebangs configure
    substituteInPlace configure --replace "which" "command -v"
    NACL_INC_DIR=${libsodium}/include/sodium NACL_LIB=sodium ./configure
  '';

  enableParallelBuilding = true;

  # All files installed to /etc are just static data that can go in the store
  makeFlags = "PREFIX=$(out) ETCDIR=$(out)/etc";

  postInstall = ''
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIP.dat		$out/etc/netsniff-ng/country4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPv6.dat		$out/etc/netsniff-ng/country6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCity.dat		$out/etc/netsniff-ng/city4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCityv6.dat	$out/etc/netsniff-ng/city6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNum.dat		$out/etc/netsniff-ng/asname4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNumv6.dat	$out/etc/netsniff-ng/asname6.dat
    rm -v $out/etc/netsniff-ng/geoip.conf # updating databases after installation is impossible
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Swiss army knife for daily Linux network plumbing";
    longDescription = ''
      netsniff-ng is a free Linux networking toolkit. Its gain of performance
      is reached by zero-copy mechanisms, so that on packet reception and
      transmission the kernel does not need to copy packets from kernel space
      to user space and vice versa. The toolkit can be used for network
      development and analysis, debugging, auditing or network reconnaissance.
    '';
    homepage = http://netsniff-ng.org/;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
