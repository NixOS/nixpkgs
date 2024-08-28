{ stdenv, lib, rustPlatform, fetchFromGitLab, pkg-config, file, perl, curl, cmake, openssl, libssh2, libgit2, libzip, Security }:

rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "0rqlxxl58dpfvm2idhi0vzinraf4bgiapmawiih9wxs599fnhm3y";
  };

  cargoHash = "sha256-NAhLTrTshCm1QKGaOdD/YaqD6c3oYZwVBst8fvTlScQ=";

  nativeBuildInputs = [ pkg-config file perl cmake curl ];
  buildInputs = [ openssl libssh2 libgit2 libzip ] ++ lib.optional stdenv.isDarwin Security;

  COMPLETION_OUT = "out";
  postInstall = ''
    install -Dm 755 "${COMPLETION_OUT}/powerline-rs.bash" "$out/share/bash-completion/completions/powerline-rs"
    install -Dm 755 "${COMPLETION_OUT}/powerline-rs.fish" "$out/share/fish/vendor_completions.d/powerline-rs"
  '';

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "powerline-rs";
  };
}
