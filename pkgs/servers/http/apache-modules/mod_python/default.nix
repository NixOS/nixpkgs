{
  apacheHttpd,
  fetchFromGitHub,
  lib,
  libintl,
  nix-update-script,
  python3,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "mod_python";
  version = "3.5.0.2";

  src = fetchFromGitHub {
    owner = "grisha";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-EH8wrXqUAOFWyPKfysGeiIezgrVc789RYO4AHeSA6t4=";
  };

  patches = [ ./install.patch ];

  installFlags = [
    "LIBEXECDIR=$(out)/modules"
    "BINDIR=$(out)/bin"
  ];

  buildInputs = [
    apacheHttpd
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    libintl
  ];

  passthru = {
    inherit apacheHttpd;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://modpython.org/";
    changelog = "https://github.com/grisha/mod_python/blob/${version}/NEWS";
    description = "Apache module that embeds the Python interpreter within the server";
    mainProgram = "mod_python";
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
