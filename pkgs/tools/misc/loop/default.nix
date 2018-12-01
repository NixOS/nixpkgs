{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "loop-unstable-2018-10-02";
  version = "d6ef3c5a0ecd4f533908abee5e481419a1a6eeae";

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo  = "Loop";
    rev   = version;
    sha256 = "1fhihm32v77rj6r3scwmnvzsivky50g7a1644qrn8pafpjs4zwx5";
  };

  cargoSha256 = "1ccf8dkswwdbwf9diy0l4vc4i2g05ynhi3w1jg3b2ldrvj0j9m9s";

  cargoPatches = [ ./fix_cargo_toml.patch ./fix_cargo_lock.patch ]; # Cargo.lock and Cargo.toml are not aligned

  meta = with stdenv.lib; {
    description = "UNIX's missing `loop` command";
    homepage = https://github.com/Miserlou/Loop;
    maintainers = with maintainers; [ koral ];
    license = licenses.mit;
  };
}
