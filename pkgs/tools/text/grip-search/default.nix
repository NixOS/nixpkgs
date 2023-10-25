{ lib, stdenv, fetchFromGitHub, boost, pkg-config, cmake, catch2 }:

stdenv.mkDerivation rec {
  pname = "grip-search";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "sc0ty";
    repo = "grip";
    rev = "v${version}";
    sha256 = "0bkqarylgzhis6fpj48qbifcd6a26cgnq8784hgnm707rq9kb0rx";
  };

  nativeBuildInputs = [ pkg-config cmake catch2 ];

  doCheck = true;

  buildInputs = [ boost ];

  patchPhase = ''
    substituteInPlace src/general/config.h --replace "CUSTOM-BUILD" "${version}"
  '';

  meta = with lib; {
    description = "Fast, indexed regexp search over large file trees";
    homepage = "https://github.com/sc0ty/grip";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ tex ];
  };
}
