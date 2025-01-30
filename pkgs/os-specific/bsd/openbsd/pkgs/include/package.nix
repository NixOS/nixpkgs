{
  mkDerivation,
  makeMinimal,
  bsdSetupHook,
  openbsdSetupHook,
  install,
  rpcgen,
  mtree,
  pax,
  buildPackages,
}:
mkDerivation {
  path = "include";
  noCC = true;

  extraPaths = [
    "lib"
    #"sys"
    "sys/arch"
    # LDIRS from the mmakefile
    "sys/crypto"
    "sys/ddb"
    "sys/dev"
    "sys/isofs"
    "sys/miscfs"
    "sys/msdosfs"
    "sys/net"
    "sys/netinet"
    "sys/netinet6"
    "sys/netmpls"
    "sys/net80211"
    "sys/nfs"
    "sys/ntfs"
    "sys/scsi"
    "sys/sys"
    "sys/ufs"
    "sys/uvm"
  ];

  nativeBuildInputs = [
    bsdSetupHook
    install
    makeMinimal
    mtree
    openbsdSetupHook
    pax
    rpcgen
  ];

  makeFlags = [
    "RPCGEN_CPP=${buildPackages.stdenv.cc.cc}/bin/cpp"
    "-B"
  ];

  headersOnly = true;
}
