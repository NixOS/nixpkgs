{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, fuse2
, unrar_6
}:

stdenv.mkDerivation rec {
  pname = "rar2fs";
  version = "1.29.6";

  src = fetchFromGitHub {
    owner = "hasse69";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b8zMCzSFJewXMQOuaKwMJx//Wq9vT/bUj6XS/jDBBBo=";
  };

  postPatch = ''
    substituteInPlace get-version.sh \
      --replace "which echo" "echo"
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ fuse2 unrar_6 ];

  configureFlags = [
    "--with-unrar=${unrar_6.src}/unrar"
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
