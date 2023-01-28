{ lib, rustPlatform, fetchFromGitHub, pkg-config, libXrandr, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hu8UYia2tu6I6Ii9aZ6vfpbrcDz4yeEDkljGFa5s6VY=";
  };

  cargoSha256 = "sha256-UOchXeBX+sDuLhwWQRVFCj9loJUyr4IltiAKsQoh5/c=";

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
