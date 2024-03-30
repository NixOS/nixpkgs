{
  curl,
  expat,
  fetchFromGitHub,
  fuse,
  gumbo,
  lib,
  libuuid,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httpdirfs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    rev = "refs/tags/${finalAttrs.version}";
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

  passthru = {
    # Disabled for Darwin because requires macFUSE installed outside NixOS
    tests.version = lib.optionalAttrs stdenv.isLinux (
      testers.testVersion {
        command = "${lib.getExe finalAttrs.finalPackage} --version";
        package = finalAttrs.finalPackage;
      }
    );
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = with lib.maintainers; [ sbruder schnusch ];
    platforms = lib.platforms.unix;
  };
})
