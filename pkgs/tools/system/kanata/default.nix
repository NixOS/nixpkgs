{ fetchFromGitHub
, fetchpatch
, lib
, libevdev
, pkg-config
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0S27dOwtHxQi5ERno040RWZNo5+ao0ULFwHKJz27wWw=";
  };

  cargoHash = "sha256-Ge9CiYIl6R8cjfUAY4B9ggjNZv5vpjmQKMPv93wGJwc=";

  cargoPatches = [
    (fetchpatch {
      name = "update-cargo.lock-for-1.0.6.patch";
      url = "https://github.com/jtroo/kanata/commit/29a7669ac230571c30c9113e5c82e8440c8b89af.patch";
      sha256 = "sha256-s4R7vUFlrL1XTNpgXRyIpIq4rDuM5A85ECzbMUX4MAw=";
    })
  ];

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
