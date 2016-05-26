{ stdenv, fetchurl, makeWrapper, pkgconfig, utillinux, which
, procps, libcap_ng, openssl, python27, iproute , perl
, kernel ? null }:

with stdenv.lib;

let
  _kernel = kernel;
in stdenv.mkDerivation rec {
  version = "2.5.0";
  name = "openvswitch-${version}";

  src = fetchurl {
    url = "http://openvswitch.org/releases/${name}.tar.gz";
    sha256 = "08bgsqjjn2q5hvxsjqs7n3jir7k7291wlj3blsqhacjhmpxm9nil";
  };

  kernel = optional (_kernel != null) _kernel.dev;

  buildInputs = [ makeWrapper pkgconfig utillinux openssl libcap_ng python27
                  perl procps which ];

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
    substituteInPlace xenserver/opt_xensource_libexec_interface-reconfigure --replace '/usr/bin/env python' '${python27.interpreter}'
    substituteInPlace vtep/ovs-vtep --replace '/usr/bin/env python' '${python27.interpreter}'
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

  meta = with stdenv.lib; {
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
    homepage = "http://openvswitch.org/";
    license = licenses.asl20;
  };
}
