{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook
, coreutils, gnugrep, gnused, lm_sensors, net-snmp, openssh, openssl, perl
, dnsutils, libdbi, libmysqlclient, zlib, openldap, procps
, runtimeShell }:

with stdenv.lib;

let
  majorVersion = "2.2";
  minorVersion = ".0";

  binPath = makeBinPath [ coreutils gnugrep gnused lm_sensors net-snmp procps ];

in stdenv.mkDerivation {
  name = "monitoring-plugins-${majorVersion}${minorVersion}";

  src = fetchFromGitHub {
    owner  = "monitoring-plugins";
    repo   = "monitoring-plugins";
    rev    = "v${majorVersion}";
    sha256 = "1pw7i6d2cnb5nxi2lbkwps2qzz04j9zd86fzpv9ka896b4aqrwv1";
  };

  patches = [
    # https://github.com/monitoring-plugins/monitoring-plugins/issues/1508
    (fetchpatch {
      url = "https://github.com/monitoring-plugins/monitoring-plugins/commit/ac0437ff896ba9ce2549b2d2ec3de146a886f08a.patch";
      sha256 = "0jf6fqkyzag66rid92m7asnr2dp8rr8kn4zjvhqg0mqvf8imppky";
    })
  ];

  # !!! Awful hack. Grrr... this of course only works on NixOS.
  # Anyway the check that configure performs to figure out the ping
  # syntax is totally impure, because it runs an actual ping to
  # localhost (which won't work for ping6 if IPv6 support isn't
  # configured on the build machine).
  preConfigure= ''
    substituteInPlace po/Makefile.in.in \
      --replace /bin/sh ${stdenv.shell}

    sed -i configure.ac \
      -e 's|^DEFAULT_PATH=.*|DEFAULT_PATH=\"\$out/bin:/run/wrappers/bin:${binPath}\"|'

    configureFlagsArray=(
      --with-ping-command='/run/wrappers/bin/ping -4 -n -U -w %d -c %d %s'
      --with-ping6-command='/run/wrappers/bin/ping -6 -n -U -w %d -c %d %s'
    )
  '';

  # !!! make openssh a runtime dependency only
  buildInputs = [ dnsutils libdbi libmysqlclient net-snmp openldap openssh openssl perl procps zlib ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  # For unknown reasons the installer tries executing $out/share and fails if
  # it doesn't succeed.
  # So we create it and remove it again later.
  preBuild = ''
    mkdir -p $out
    cat <<_EOF > $out/share
#!${runtimeShell}
exit 0
_EOF
    chmod 755 $out/share
  '';

  postInstall = ''
    rm $out/share
    ln -s libexec $out/bin
  '';

  meta = {
    description = "Official monitoring plugins for Nagios/Icinga/Sensu and others.";
    homepage    = https://www.monitoring-plugins.org;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice relrod ];
  };
}
