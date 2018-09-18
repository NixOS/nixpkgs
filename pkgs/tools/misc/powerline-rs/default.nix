{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, file, perl, curl, cmake, openssl, libssh2, libgit2, libzip, Security }:
rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  name = "${pname}-${version}";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "018i9qq98afbgv0nxs1n83zb09lqhqxpdrd95f2maic3rr5ngnj5";
  };

  cargoSha256 = "184s432a6damzvl0lv6jar1iml9dq60r190aqjy44lcg938981zc";

  nativeBuildInputs = [ pkgconfig file perl cmake curl ];
  buildInputs = [ openssl libssh2 libgit2 libzip ] ++ lib.optional stdenv.isDarwin Security;

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
