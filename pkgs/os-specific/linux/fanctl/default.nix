{ stdenv, lib, fetchbzr, makeWrapper, bridge-utils, iproute, dnsmasq, iptables, kmod, utillinux }:

stdenv.mkDerivation rec {
  name = "fanctl-${version}";

  version = "0.3.0";

  src = fetchbzr {
    url = "https://code.launchpad.net/~ubuntu-branches/ubuntu/vivid/ubuntu-fan/vivid-updates";
    rev = 2;
    sha256 = "1vcr2rg99g7sx1zynhiggjzc9y9z591i4535hbm21dysy3cisp7i";
  };

  buildInputs = [ makeWrapper ];

  # When given --conf-file="", dnsmasq still attempts to read /etc/dnsmasq.conf;
  # if that files does not exist, dnsmasq subsequently fails,
  # so we'll use /dev/null.
  #
  # Also, make sure /var/lib/ubuntu-fan exists before starting dnsmasq.
  buildPhase = ''
    substituteInPlace fanctl \
      --replace '--conf-file= ' \
                '--conf-file=/dev/null ' \
      --replace '/var/lib/misc' \
                '/var/lib/ubuntu-fan'

    sed -i '/dnsmasq -u/i \
    mkdir -p /var/lib/ubuntu-fan' fanctl
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp fanctl.8 $out/man/man8
    cp fanctl $out/bin
    wrapProgram $out/bin/fanctl --prefix PATH : \
      ${lib.makeSearchPath "bin" [ bridge-utils iproute dnsmasq iptables kmod utillinux ]};
  '';

  meta = with lib; {
    description = "Ubuntu FAN network support enablement";
    homepage = "https://launchpad.net/ubuntu/+source/ubuntu-fan";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
