{ stdenv
, lib
, fetchFromGitHub
, ruby
, makeWrapper
, getent               # /etc/passwd
, ncurses              # tput
, procps               # ps
, binutils-unwrapped   # strings
, coreutils
, findutils
}:

# No gems used, so mkDerivation is fine.
let
  additionalPath = lib.makeBinPath [ getent ncurses binutils-unwrapped coreutils findutils ];
in
stdenv.mkDerivation rec {
  name = "nix-top-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "nix-top";
    rev = "v${version}";
    sha256 = "0560a9g8n4p764r3va1nn95iv4bg71g8h0wws1af2p5g553j4zps";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    ruby
  ];

  installPhase = ''
    mkdir -p $out/libexec/nix-top
    install -D -m755 ./nix-top $out/bin/nix-top
    wrapProgram $out/bin/nix-top \
      --prefix PATH : "$out/libexec/nix-top:${additionalPath}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s /bin/stty $out/libexec/nix-top
  '';

  meta = with lib; {
    description = "Tracks what nix is building";
    homepage = https://github.com/samueldr/nix-top;
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux ++ platforms.darwin;
    inherit version;
  };
}
