{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, fuse }:

stdenv.mkDerivation rec {
  pname = "afuse";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pcarrier";
    repo = "afuse";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-KpysJRvDx+12BSl9pIGRqbJAM4W1NbzxMgDycGCr2RM=";
=======
    sha256 = "06i855h8a1w2jfly2gfy7vwhb2fp74yxbf3r69s28lki2kzwjar6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix the build on macOS with macFUSE installed
    substituteInPlace configure.ac --replace \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' \
      ""
  '';

  meta = {
    description = "Automounter in userspace";
    homepage = "https://github.com/pcarrier/afuse";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
