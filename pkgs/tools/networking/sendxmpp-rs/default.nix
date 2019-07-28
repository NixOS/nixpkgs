{ stdenv, rustPlatform, pkgconfig, openssl, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "sendxmpp-rs";
  version = "unstable-2019-03-02";

  src = fetchFromGitHub {
    owner = "moparisthebest";
    repo = "sendxmpp-rs";
    rev = "37b5efd4b62c416e6f47f44ab57a42b61ee3dbcb";
    sha256 = "0x847xla6655z587jinbk9msp1l3w4pnq2kxpmm1al7g128j9n1y";
  };

  nativeBuildInputs = [ pkgconfig openssl ];
  cargoSha256 = "0qiwrq44f388vx3gww65b1im2xfv6q8sph9608bq5xghp9qfjn69";

  meta = with stdenv.lib; {
    description = "sendxmpp in rust";
    homepage = "https://github.com/moparisthebest/sendxmpp-rs";
    license = licenses.gpl3;
    maintainers = [ ajs124 das_j ];
  };
}
