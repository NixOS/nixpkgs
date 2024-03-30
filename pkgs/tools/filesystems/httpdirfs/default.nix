{
  curl,
  expat,
  fetchFromGitHub,
  fuse,
  gumbo,
  lib,
  libuuid,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "httpdirfs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-rdeBlAV3t/si9x488tirUGLZRYAxh13zdRIQe0OPd+A=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    expat
    fuse
    gumbo
    libuuid
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "A FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = with lib.maintainers; [ sbruder schnusch ];
    platforms = lib.platforms.unix;
  };
}
