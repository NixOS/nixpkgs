{ stdenv, rubygems, rubyLibs, ruby, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gem-nix";

  buildInputs = [ ruby rubygems rubyLibs.nix makeWrapper ];

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    echo 'exec ${rubygems}/bin/gem nix "$@"' >> $out/bin/gem-nix
    chmod +x $out/bin/gem-nix
    wrapProgram $out/bin/gem-nix \
      --set GEM_PATH $GEM_PATH
  '';

  meta = with stdenv.lib; {
    description = "gem nix command in a nice wrapper";
    platforms = platforms.unix;
    maintainers = [ maintainers.iElectric ];
  };
}
