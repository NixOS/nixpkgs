{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3EaVUGcwkJWX0FxIaHddUehJIdbxAPfBm8esXKCUuhM=";
  };

  vendorSha256 = "sha256-Oko9nduKW76NIUCVyF0lPzEH+TFT1el9VGIbm5lQXtM=";

  ldflags = [ "-s" "-w" "-X github.com/jpillora/chisel/share.BuildVersion=${version}" ];

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
