{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "gir";
  version = "2019-10-16";

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = "241d790085a712db7436c5c25b210ccb7d1a08d5";
    sha256 = "1kn5kgdma9j6dwpmv6jmydak7ajlgdkw9sfkh3q7h8c2a8yikvxr";
  };

  cargoSha256 = "0sadd0snyqd82y5bwbgfxhbw1jrszwwlz29gq7zb4kbr4j8z3f5n";

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
