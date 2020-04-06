{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, libXrandr, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.2.0";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libXrandr libX11 ];

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "tJnF1X+NI1hP0J/n3rGy8TD/yIveqRPVlJvJvn0C7Do=";
  };

  cargoSha256 = "0sbhij8qh9n05nzhp47dm46hbc59awar515f9nhd3wvahwz53zam";

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ lumi ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
