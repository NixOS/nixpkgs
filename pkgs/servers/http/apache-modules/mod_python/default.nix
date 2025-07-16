{
  apacheHttpd,
  ensureNewerSourcesForZipFilesHook,
  fetchFromGitHub,
  lib,
  libintl,
  nix-update-script,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mod_python";
  version = "3.5.0.4";

  src = fetchFromGitHub {
    owner = "grisha";
    repo = "mod_python";
    tag = finalAttrs.version;
    hash = "sha256-bZ0w61+0If70KD3UW24JllY6vD0vQX2C7FssYG1YLPI=";
  };

  patches = [ ./install.patch ];

  installFlags = [
    "LIBEXECDIR=$(out)/modules"
    "BINDIR=$(out)/bin"
  ];

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs =
    [
      apacheHttpd
      (python3.withPackages (
        ps: with ps; [
          distutils
          packaging
          setuptools
        ]
      ))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libintl
    ];

  passthru = {
    inherit apacheHttpd;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://modpython.org/";
    changelog = "https://github.com/grisha/mod_python/blob/master/NEWS";
    description = "Apache module that embeds the Python interpreter within the server";
    mainProgram = "mod_python";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
