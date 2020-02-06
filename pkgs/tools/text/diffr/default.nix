{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diffr";
  version = "v0.1.2";

  # diffr's tests expect the diffr binary to be at `$CARGO_MANIFEST_DIR/target/debug/diffr`.
  doCheck = false;

  src = fetchFromGitHub {
    owner = "mookid";
    repo = pname;
    rev = version;
    sha256 = "1fpcyl4kc4djfl6a2jlj56xqra42334vygz8n7614zgjpyxz3zx2";
  };

  cargoSha256 = "1dddb3a547qnpm1vvrgffb3v9m8sh19hmhy0fg6xjqpm032lqx3v";

  nativeBuildInputs = [];
  buildInputs = (stdenv.lib.optional stdenv.isDarwin Security);

  meta = with stdenv.lib; {
    description = "Yet another diff highlighting tool";
    homepage = https://github.com/mookid/diffr;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
