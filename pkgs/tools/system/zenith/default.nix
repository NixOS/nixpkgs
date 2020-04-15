{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "1s1l4nq4bsvi54i603faann8cp1409qa2ka7id0m38b3li8z2984";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0h6k7yf4hpfxnad46iv8gp3v3zc4x4p9yab40gr8xv8r1syf9f6g";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    platforms = platforms.x86;
  };
}
