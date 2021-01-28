{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dayc0mbvybsydx2r170m5cfmf0p4896vk9xawpk7gncxclrwpv6";
  };

  vendorSha256 = "01wh8fn76jn8hnf7gj759k8dwqrr0p36xmsxfc8dayzinpl10fqv";

  # tests require access to the network
  doCheck = false;

  meta = with lib; {
    description = "TCP/UDP tunnel over HTTP";
    longDescription = ''
      Chisel is a fast TCP/UDP tunnel, transported over HTTP, secured via
      SSH. Single executable including both client and server. Chisel is
      mainly useful for passing through firewalls, though it can also be
      used to provide a secure endpoint into your network.
    '';
    homepage = "https://github.com/jpillora/chisel";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
