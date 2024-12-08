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
  version = "3.5.0.2";

  src = fetchFromGitHub {
    owner = "grisha";
    repo = "mod_python";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-++yHNKVe1u3w47DaB0zvYyuTrBcQdmuDm22areAeejs=";
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
      (python3.withPackages (ps: with ps; [
        distutils
        packaging
        setuptools
      ]))
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
  };
})
