{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  libplist,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldid-procursus";
  version = "2.1.5-procursus7";

  src = fetchFromGitHub {
    owner = "ProcursusTeam";
    repo = "ldid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QnSmWY9zCOPYAn2VHc5H+VQXjTCyr0EuosxvKGGpDtQ=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    libplist
    openssl
  ];

  stripDebugFlags = [ "--strip-unneeded" ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  postInstall = ''
    installShellCompletion --cmd ldid --zsh _ldid
  '';

  meta = with lib; {
    mainProgram = "ldid";
    description = "Put real or fake signatures in a Mach-O binary";
    homepage = "https://github.com/ProcursusTeam/ldid";
    maintainers = with maintainers; [ keto ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
})
