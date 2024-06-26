{ lib
, stdenv
, fetchFromGitea
, rustPlatform
, pkg-config
, git
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fedigroups";
  version = "0.4.5";

  src = fetchFromGitea {
    domain = "git.ondrovo.com";
    owner = "MightyPork";
    repo = "group-actor";
    rev = "v${version}";
    sha256 = "sha256-NMqoYUNN2ntye9mNC3KAAc0DBg+QY7+6/DASwHPexY0=";
    forceFetchGit = true; # Archive generation is disabled on this gitea instance
    leaveDotGit = true; # git command in build.rs
  };

  # The lockfile in the repo is not up to date
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "elefren-0.22.0" = "sha256-zCmopdkBHT0gzNGQqZzsnIyMyAt0XBbQdOCpegF6TsY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    openssl
  ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    homepage = "https://git.ondrovo.com/MightyPork/group-actor#fedi-groups";
    downloadPage = "https://git.ondrovo.com/MightyPork/group-actor/releases";
    description = "Approximation of groups usable with Fediverse software that implements the Mastodon client API";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "fedigroups";
  };
}
