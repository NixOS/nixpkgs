{ stdenv
, lib
, fetchFromGitHub
, ruby
, makeWrapper
, procps               # ps
, ncurses              # tput
, binutils-unwrapped   # strings
, findutils
}:

# No gems used, so mkDerivation is fine.
let
  additionalPath = lib.makeBinPath [ncurses procps binutils-unwrapped findutils];
in
stdenv.mkDerivation rec {
  name = "nix-top-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "nix-top";
    rev = "v${version}";
    sha256 = "0l50w90hs3kmdk5kb3cwjzkx38104j6n4ssqs6jpnqfc2znagpni";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    ruby
  ];
  
  installPhase = ''
    mkdir -p $out/bin/
    cp ./nix-top $out/bin/nix-top
    wrapProgram $out/bin/nix-top \
      --prefix PATH : "${additionalPath}"
  '';

  meta = with lib; {
    description = "Tracks what nix is building";
    homepage = https://github.com/samueldr/nix-top;
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux;
    inherit version;
  };
}
