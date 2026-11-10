{
  mkDerivation,
  libpcap,
  openssl,
}:
mkDerivation {
  path = "usr.sbin/wpa";
  extraPaths = [
    "contrib/wpa"
  ];
  buildInputs = [
    libpcap
    openssl
  ];
}
