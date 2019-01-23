{ stdenv, lib, rustPlatform, fetchFromGitLab, pkgconfig, file, perl, curl, cmake, openssl, libssh2, libgit2, libzip, Security }:
rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  name = "${pname}-${version}";
  version = "0.1.9";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    #rev = version;

    # Support for $COMPLETION_OUT:
    rev = "44679385a95dd9f3ebd9b093f9ef8925610e9a23";

    sha256 = "1mxkw6ydnqjyplbki2j9pbnlhxmkw9qqw54443a3cjmn2g08jyzp";
  };

  cargoSha256 = "1sr9vbfk5bb3n0lv93y19in1clyvbj0w3p1gmp4sbw8lx84zwxhc";

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
