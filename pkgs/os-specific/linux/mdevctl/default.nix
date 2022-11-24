{ lib, fetchFromGitHub
, rustPackages, pkg-config, docutils
}:

rustPackages.rustPlatform.buildRustPackage rec {

  pname = "mdevctl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    hash = "sha256-Hgl+HsWAYIdabHJdPbCaBNnhY49vpuIjR3l6z2CAmx0=";
  };

  cargoPatches = [ ./lock.patch ];

  cargoHash = "sha256-PXVc7KUMPze06gCnD2gqzlySwPumOw/z31CTd0UHp9w=";

  nativeBuildInputs = [ pkg-config docutils ];

  meta = with lib; {
    homepage = "https://github.com/mdevctl/mdevctl";
    description = "A mediated device management utility for linux";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
