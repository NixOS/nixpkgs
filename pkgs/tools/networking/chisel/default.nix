{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1vg9tJLYbW8pfPpw3gQ15c9Kwj2lFfblMRhOK4yWKb8=";
  };

  vendorSha256 = "sha256-GzsQ6LXxe9UQc13XbsYFOWPe0EzlyHechchKc6xDkAc=";

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
