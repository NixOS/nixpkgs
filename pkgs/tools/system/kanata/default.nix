{ fetchFromGitHub
, lib
, libevdev
, pkg-config
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sL9hP+222i8y0sK3ZEx66yXBTgZp5ewoPUlZS4XnphY=";
  };

  cargoHash = "sha256-uhN1UdwtU0C0/lpxUYoCcMLABFTPNO5wKsIGOBnFpzw=";

  buildFeatures = lib.optional withCmd "cmd";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libevdev ];

  meta = with lib; {
    description = "A cross-platform advanced keyboard customization tool";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
  };
}
