{ stdenv, fetchurl, openssl, python27, iproute, perl, kernel ? null}:
let

  version = "2.1.2";

  skipKernelMod = kernel == null;

in
stdenv.mkDerivation {
  version = "2.1.2";
  name = "openvswitch-${version}";
  src = fetchurl {
    url = "http://openvswitch.org/releases/openvswitch-2.1.2.tar.gz";
    sha256 = "16q7faqrj2pfchhn0x5s9ggi5ckcg9n62f6bnqaih064aaq2jm47";
  };
  kernel = if skipKernelMod then null else kernel.dev;
  buildInputs = [
    openssl
    python27
    perl
  ];
  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--sbindir=$(out)/bin"
  ] ++ (if skipKernelMod then [] else ["--with-linux"]);
  # Leave /var out of this!
  installFlags = [
    "LOGDIR=$(TMPDIR)/dummy"
    "RUNDIR=$(TMPDIR)/dummy"
    "PKIDIR=$(TMPDIR)/dummy"
  ];
  meta = {
    platforms = stdenv.lib.platforms.linux;
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
    licence = "Apache 2.0";
  };
}
