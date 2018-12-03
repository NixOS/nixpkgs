{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "loop-unstable-2018-10-02";

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo  = "Loop";
    rev   = "d6ef3c5a0ecd4f533908abee5e481419a1a6eeae";
    sha256 = "1fhihm32v77rj6r3scwmnvzsivky50g7a1644qrn8pafpjs4zwx5";
  };

  cargoSha256 = "1ccf8dkswwdbwf9diy0l4vc4i2g05ynhi3w1jg3b2ldrvj0j9m9s";

  cargoPatches = [
    # Upstream includes mismatched Cargo.lock file.
    # See https://github.com/Miserlou/Loop/pull/40
    ./fix_cargo_lock.patch
  ];

  meta = with stdenv.lib; {
    description = "UNIX's missing `loop` command";
    homepage = https://github.com/Miserlou/Loop;
    maintainers = with maintainers; [ koral ];
    license = licenses.mit;
  };
}
