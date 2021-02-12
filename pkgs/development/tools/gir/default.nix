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

  cargoSha256 = "074dvgxxv7y2j7nsk9q1p8my7lyndm05mdp51lpkss6h398na4g5";

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
