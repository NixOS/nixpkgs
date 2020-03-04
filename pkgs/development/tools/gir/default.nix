{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "gir";
  version = "2019-10-16";

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = "241d790085a712db7436c5c25b210ccb7d1a08d5";
    sha256 = "1kn5kgdma9j6dwpmv6jmydak7ajlgdkw9sfkh3q7h8c2a8yikvxr";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1ybd9h2f13fxmnkzbacd39rcyzjcjd2ra52y8kncg1s0dc0m8rjb";

  meta = with stdenv.lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = https://github.com/gtk-rs/gir/;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.all;
  };
}
