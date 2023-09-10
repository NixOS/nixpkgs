{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, libiconv
, Security
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

  cargoSha256 = "1g15v13ysx09fy0b8qddw5fwql2pvwzc2g2h1ndhzpxvfy7fzpr1";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoPatches = [
    # Add Cargo.lock file, https://github.com/rozgo/anevicon/pull/1
    (fetchpatch {
      name = "cargo-lock-file.patch";
      url = "https://github.com/rozgo/anevicon/commit/205440a0863aaea34394f30f4255fa0bb1704aed.patch";
      sha256 = "02syzm7irn4slr3s5dwwhvg1qx8fdplwlhza8gfkc6ajl7vdc7ri";
    })
  ];

  # Tries to send large UDP packets that Darwin rejects.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "UDP-based load generator";
    homepage = "https://github.com/rozgo/anevicon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
