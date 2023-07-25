{ lib, stdenv, fetchFromGitHub, pkg-config, libpng, zlib }:

stdenv.mkDerivation rec {
  pname = "pngloss";
  version = "unstable-2020-11-25";

  src = fetchFromGitHub {
    owner = "foobaz";
    repo = pname;
    rev = "559f09437e1c797a1eaf08dfdcddd9b082f0e09c";
    sha256 = "sha256-dqrrzbLu4znyWOlTDIf56O3efxszetiP+CdFiy2PBd4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpng
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -D ./src/pngloss $out/bin/pngloss

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lossy compression of PNG images";
    homepage = "https://github.com/foobaz/pngloss";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ _2gn ];
  };
}
