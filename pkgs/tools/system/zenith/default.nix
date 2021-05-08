{ lib, stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "1bn364rmp0q86rd7vgv4n7x09cdf9m4njcaq92jnk85ni6h147ax";
  };

  cargoSha256 = "0c2mk2bcz4qjyqmf11yqhnhy4pqxr77b3c1gvr5jfmjshx4ff7v2";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    # see https://github.com/NixOS/nixpkgs/pull/88616
    platforms = platforms.x86;
  };
}
