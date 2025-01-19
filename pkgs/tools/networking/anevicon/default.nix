{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  libiconv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "anevicon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rozgo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m3ci7g7nn28p6x5m85av3ljgszwlg55f1hmgjnarc6bas5bapl7";
  };

  cargoHash = "sha256-Id/vjne73w+bDVA8wT7fV1DMXeGtYbSAdwl07UfYJbw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Security
  ];

  cargoPatches = [
    # Add Cargo.lock file, https://github.com/rozgo/anevicon/pull/1
    (fetchpatch {
      name = "cargo-lock-file.patch";
      url = "https://github.com/rozgo/anevicon/commit/205440a0863aaea34394f30f4255fa0bb1704aed.patch";
      sha256 = "02syzm7irn4slr3s5dwwhvg1qx8fdplwlhza8gfkc6ajl7vdc7ri";
    })
  ];

  # Tries to send large UDP packets that Darwin rejects.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "UDP-based load generator";
    homepage = "https://github.com/rozgo/anevicon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "anevicon";
  };
}
