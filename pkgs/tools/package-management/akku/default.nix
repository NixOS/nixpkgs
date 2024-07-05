{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, guile, curl, substituteAll }:

stdenv.mkDerivation rec {
  pname = "akku";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "akkuscm";
    repo = "akku";
    rev = "v${version}";
    sha256 = "1pi18aamg1fd6f9ynfl7zx92052xzf0zwmhi2pwcwjs1kbah19f5";
  };

  patches = [
    # substitute libcurl path
    (substituteAll {
      src = ./hardcode-libcurl.patch;
      libcurl = "${curl.out}/lib/libcurl${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ guile ];

  # Use a dummy package index to boostrap Akku
  preBuild = ''
    touch bootstrap.db
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = with lib; {
    homepage = "https://akkuscm.org/";
    description = "Language package manager for Scheme";
    changelog = "https://gitlab.com/akkuscm/akku/-/raw/v${version}/NEWS.md";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "akku";
  };
}
