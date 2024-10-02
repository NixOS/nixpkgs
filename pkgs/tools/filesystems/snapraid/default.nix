{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  smartmontools,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "snapraid";
  version = "12.3";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    hash = "sha256-pkLooA3JZV/rPlE5+JeJN1QW2xAdNu7c/iFFtT4M4vc=";
  };

  VERSION = version;

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  buildInputs = [ ];

  # SMART is only supported on Linux and requires the smartmontools package
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/snapraid \
     --prefix PATH : ${lib.makeBinPath [ smartmontools ]}
  '';

  meta = {
    homepage = "http://www.snapraid.it/";
    description = "Backup program for disk arrays";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
    mainProgram = "snapraid";
  };
}
