{ lib, fetchFromGitHub, rustPlatform, pkg-config, libXrandr, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.2.0";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libXrandr libX11 ];

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fpc09yvxjcvjkai7afyig4gyc7inaqxxrwzs17mh8wdgzawb6dl";
  };

  cargoSha256 = "06zplpy480965lhgav984m6wkfijv7cqa49kpramp8b6ws62pikl";

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ lumi ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
