{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive
, pkg-config, gettext, libssl, txt2man }:

stdenv.mkDerivation rec {
  pname = "axel";
  version = "2.17.14";

  src = fetchFromGitHub {
    owner = "axel-download-accelerator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5GUna5k8GhAx1Xe8n9IvXT7IO6gksxCLh+sMANlxTBM=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config autoconf-archive txt2man ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=${placeholder "out"}/etc" ];

  postInstall = ''
    mkdir -p $out/share/doc
    cp doc/axelrc.example $out/share/doc/axelrc.example
  '';

  meta = with lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = "https://github.com/axel-download-accelerator/axel";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    license = licenses.gpl2Plus;
    mainProgram = "axel";
  };
}
