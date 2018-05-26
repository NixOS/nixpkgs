{ stdenv, fetchFromGitHub, makeWrapper, bison, flex, geoip, geolite-legacy
, libcli, libnet, libnetfilter_conntrack, libnl, libpcap, libsodium
, liburcu, ncurses, perl, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "netsniff-ng-${version}";
  version = "0.6.4";

  # Upstream recommends and supports git
  src = fetchFromGitHub rec {
    repo = "netsniff-ng";
    owner = repo;
    rev = "v${version}";
    sha256 = "0nip1gmzxq5kak41n0y0qzbhk2876fypk83q14ssy32fk49lxjly";
  };

  patches = [ ./glibc-2.26.patch ];

  buildInputs = [ bison flex geoip geolite-legacy libcli libnet libnl
    libnetfilter_conntrack libpcap libsodium liburcu ncurses perl
    pkgconfig zlib makeWrapper ];

  # ./configure is not autoGNU but some home-brewn magic
  configurePhase = ''
    patchShebangs configure
    substituteInPlace configure --replace "which" "command -v"
    NACL_INC_DIR=${libsodium.dev}/include/sodium NACL_LIB=sodium ./configure
  '';

  enableParallelBuilding = true;

  # All files installed to /etc are just static data that can go in the store
  makeFlags = [ "PREFIX=$(out)" "ETCDIR=$(out)/etc" ];

  postInstall = ''
    # trafgen and bpfc can call out to cpp to process config files.
    wrapProgram "$out/sbin/trafgen" --prefix PATH ":" "${stdenv.cc}/bin"
    wrapProgram "$out/sbin/bpfc" --prefix PATH ":" "${stdenv.cc}/bin"

    ln -sv ${geolite-legacy}/share/GeoIP/GeoIP.dat		$out/etc/netsniff-ng/country4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPv6.dat		$out/etc/netsniff-ng/country6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCity.dat		$out/etc/netsniff-ng/city4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCityv6.dat	$out/etc/netsniff-ng/city6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNum.dat		$out/etc/netsniff-ng/asname4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNumv6.dat	$out/etc/netsniff-ng/asname6.dat
    rm -v $out/etc/netsniff-ng/geoip.conf # updating databases after installation is impossible
  '';

  meta = with stdenv.lib; {
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
    platforms = platforms.linux;
  };
}
