{ lib, rustPlatform, fetchFromGitHub, pkg-config, libXrandr, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fcb+eZXzpuEPFSZexbgDpoBX85gsiIqPlcPXruNGenk=";
  };

  cargoSha256 = "sha256-n5HPl2h0fr0MyGBivNVrrs23HAllIYtwaw1aaKWHCe4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libXrandr libX11 ];

  # build script tries to run git to get the current tag
  postPatch = ''
    echo "fn main() {}" > build.rs
  '';

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda lumi ];
    platforms = platforms.linux;
  };
}
