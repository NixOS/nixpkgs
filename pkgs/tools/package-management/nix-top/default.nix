{
  stdenv,
  lib,
  fetchFromGitHub,
  ruby,
  makeWrapper,
  getent, # /etc/passwd
  ncurses, # tput
  binutils-unwrapped, # strings
  coreutils,
  findutils,
}:

# No gems used, so mkDerivation is fine.
let
  additionalPath = lib.makeBinPath [
    getent
    ncurses
    binutils-unwrapped
    coreutils
    findutils
  ];
in
stdenv.mkDerivation rec {
  pname = "nix-top";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "nix-top";
    rev = "v${version}";
    sha256 = "sha256-w/TKzbZmMt4CX2KnLwPvR1ydp5NNlp9nNx78jJvhp54=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    ruby
  ];

  installPhase =
    ''
      mkdir -p $out/libexec/nix-top
      install -D -m755 ./nix-top $out/bin/nix-top
      wrapProgram $out/bin/nix-top \
        --prefix PATH : "$out/libexec/nix-top:${additionalPath}"
    ''
    + lib.optionalString stdenv.isDarwin ''
      ln -s /bin/stty $out/libexec/nix-top
    '';

  meta = with lib; {
    description = "Tracks what nix is building";
    homepage = "https://github.com/samueldr/nix-top";
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "nix-top";
  };
}
