{ stdenv, fetchurl, makeWrapper, pkgconfig, utillinux, which
, procps, libcap_ng, openssl, python3 , perl
, kernel ? null }:

with stdenv.lib;

let
  _kernel = kernel;
  pythonEnv = python3.withPackages (ps: with ps; [ six ]);
in stdenv.mkDerivation rec {
  version = "2.13.3";
  pname = "openvswitch";

  src = fetchurl {
    url = "https://www.openvswitch.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1wc5zspy9aln7di7m9a1qy4lv3h05gmhgd1nffhb9nxdcxqgnpgp";
  };

  kernel = optional (_kernel != null) _kernel.dev;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ makeWrapper utillinux openssl libcap_ng pythonEnv
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
    substituteInPlace xenserver/opt_xensource_libexec_interface-reconfigure --replace '/usr/bin/env python' '${pythonEnv.interpreter}'
    substituteInPlace vtep/ovs-vtep --replace '/usr/bin/env python' '${pythonEnv.interpreter}'
  '';

  enableParallelBuilding = true;
  doCheck = false; # bash-completion test fails with "compgen: command not found"

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
    homepage = "https://www.openvswitch.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ netixx kmcopper ];
  };
}
