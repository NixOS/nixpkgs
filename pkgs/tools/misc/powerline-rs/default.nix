{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, file, perl, curl, cmake, openssl_1_1_0, libssh2, libgit2, libzip, Security }:
rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  name = "${pname}-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "0ry1axia78sp9vmn6p119l69sj3dqx2san1k71a5npf60rf4gfkc";
  };

  cargoSha256 = "184s432a6damzvl0lv6jar1iml9dq60r190aqjy44lcg938981zc";

  nativeBuildInputs = [ pkgconfig file perl cmake curl ];
  buildInputs = [ openssl_1_1_0 libssh2 libgit2 libzip ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    install -Dm 755 "${pname}.bash" "$out/etc/bash_completion.d/${pname}"
    install -Dm 755 "${pname}.fish" "$out/share/fish/vendor_completions.d/${pname}"
  '';

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
