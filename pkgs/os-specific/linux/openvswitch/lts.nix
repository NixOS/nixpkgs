{ lib, stdenv, fetchurl, makeWrapper, pkg-config, util-linux, which
, procps, libcap_ng, openssl, python2, iproute , perl
, automake, autoconf, libtool, kernel ? null }:

with lib;

let
  _kernel = kernel;
in stdenv.mkDerivation rec {
  version = "2.5.9";
  pname = "openvswitch";

  src = fetchurl {
    url = "https://www.openvswitch.org/releases/${pname}-${version}.tar.gz";
    sha256 = "0iv0ncwl6s4qyyb655yj5xvqrjr1zbymmab96q259wa09xnyw7b7";
  };

  patches = [ ./patches/lts-ssl.patch ];

  kernel = optional (_kernel != null) _kernel.dev;

  nativeBuildInputs = [ autoconf libtool automake pkg-config makeWrapper ];
  buildInputs = [ util-linux openssl libcap_ng python2 perl procps which ];

  preConfigure = "./boot.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--sbindir=$(out)/bin"
  ] ++ (optionals (_kernel != null) ["--with-linux"]);

  # Leave /var out of this!
  installFlags = [
    "LOGDIR=$(TMPDIR)/dummy"
    "RUNDIR=$(TMPDIR)/dummy"
    "PKIDIR=$(TMPDIR)/dummy"
  ];

  postBuild = ''
    # fix tests
    substituteInPlace xenserver/opt_xensource_libexec_interface-reconfigure --replace '/usr/bin/env python' '${python2.interpreter}'
    substituteInPlace vtep/ovs-vtep --replace '/usr/bin/env python' '${python2.interpreter}'
  '';

  enableParallelBuilding = true;
  doCheck = false; # bash-completion test fails with "compgen: command not found"

  postInstall = ''
    cp debian/ovs-monitor-ipsec $out/share/openvswitch/scripts
    makeWrapper \
      $out/share/openvswitch/scripts/ovs-monitor-ipsec \
      $out/bin/ovs-monitor-ipsec \
      --prefix PYTHONPATH : "$out/share/openvswitch/python"
    substituteInPlace $out/share/openvswitch/scripts/ovs-monitor-ipsec \
      --replace "UnixctlServer.create(None)" "UnixctlServer.create(os.environ['UNIXCTLPATH'])"
    substituteInPlace $out/share/openvswitch/scripts/ovs-monitor-ipsec \
      --replace "self.psk_file" "root_prefix + self.psk_file"
    substituteInPlace $out/share/openvswitch/scripts/ovs-monitor-ipsec \
      --replace "self.cert_dir" "root_prefix + self.cert_dir"
  '';

  meta = with lib; {
    platforms = platforms.linux;
    description = "A multilayer virtual switch";
    longDescription =
      ''
      Open vSwitch is a production quality, multilayer virtual switch
      licensed under the open source Apache 2.0 license. It is
      designed to enable massive network automation through
      programmatic extension, while still supporting standard
      management interfaces and protocols (e.g. NetFlow, sFlow, SPAN,
      RSPAN, CLI, LACP, 802.1ag). In addition, it is designed to
      support distribution across multiple physical servers similar
      to VMware's vNetwork distributed vswitch or Cisco's Nexus 1000V.
      '';
    homepage = "https://www.openvswitch.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ netixx kmcopper ];
  };
}
