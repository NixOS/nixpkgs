{ stdenv, lib, rustPlatform, fetchFromGitLab, pkgconfig, file, perl, curl, cmake, openssl, libssh2, libgit2, libzip, Security }:

rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "0rqlxxl58dpfvm2idhi0vzinraf4bgiapmawiih9wxs599fnhm3y";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1vdx5nwj4qmkb3rdgnchd9xixc5pmhvskvn6dmqgm91s41p2al1p";

  nativeBuildInputs = [ pkgconfig file perl cmake curl ];
  buildInputs = [ openssl libssh2 libgit2 libzip ] ++ lib.optional stdenv.isDarwin Security;

  COMPLETION_OUT = "out";
  postInstall = ''
    install -Dm 755 "${COMPLETION_OUT}/${pname}.bash" "$out/etc/bash_completion.d/${pname}"
    install -Dm 755 "${COMPLETION_OUT}/${pname}.fish" "$out/share/fish/vendor_completions.d/${pname}"
  '';

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
