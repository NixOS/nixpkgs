{ lib, fetchFromGitHub, buildGoPackage, m4 }:

buildGoPackage rec {
  pname = "localtime";
  version = "unstable-2017-11-07";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = "localtime";
    rev = "2e7b4317c723406bd75b2a1d640219ab9f8090ce";
    sha256 = "04fyna8p7q7skzx9fzmncd6gx7x5pwa9jh8a84hpljlvj0kldfs8";
  };

  goPackagePath = "github.com/Stebalien/localtime";

  nativeBuildInputs = [ m4 ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
  ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    make $makeFlags
  '';

  installPhase = ''
    make install $makeFlags
  '';

  meta = with lib; {
    description = "A daemon for keeping the system timezone up-to-date based on the current location";
    homepage = "https://github.com/Stebalien/localtime";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
