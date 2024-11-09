{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, fuse2
, unrar
}:

stdenv.mkDerivation rec {
  pname = "rar2fs";
  version = "1.29.7";

  src = fetchFromGitHub {
    owner = "hasse69";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iYlmNtaJZrnsNNNlaoV1Vu6PHrHIr/glhgs3784JCm4=";
  };

  postPatch = ''
    substituteInPlace get-version.sh \
      --replace "which echo" "echo"
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ fuse2 unrar ];

  configureFlags = [
    "--with-unrar=${unrar.src}/unrar"
    "--disable-static-unrar"
  ];

  meta = with lib; {
    description = "FUSE file system for reading RAR archives";
    homepage = "https://hasse69.github.io/rar2fs/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kraem wegank ];
    platforms = with platforms; linux ++ freebsd;
  };
}
