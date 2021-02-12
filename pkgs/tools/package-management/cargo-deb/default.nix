{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, rust
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "b49351f6770aa7aeb053dd1d4a02d6b086caad2a";
    sha256 = "1hs96yv0awgi7ggpxp7k3n21jpv642sm0529b21hs9ib6kp4vs8s";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0y1x4318jqajdz33np9dhm148w61c97m75vinqvm0zpzyv0nnawm";

  checkType = "debug";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/debug"
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
