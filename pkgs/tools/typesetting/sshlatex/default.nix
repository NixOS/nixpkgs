{ stdenv, fetchFromGitHub, inotify-tools, openssh, perl, gnutar, bash, makeWrapper }:

stdenv.mkDerivation rec {
  name = "sshlatex-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "iblech";
    repo = "sshlatex";
    rev = "${version}";
    sha256 = "02h81i8n3skg9jnlfrisyg5bhqicrn6svq64kp20f70p64s3d7ix";
  };

  buildInputs = [ makeWrapper ];

  installPhase = let
    binPath = stdenv.lib.makeBinPath [ openssh perl gnutar bash inotify-tools ];
  in ''
    mkdir -p $out/bin
    cp sshlatex $out/bin
    wrapProgram $out/bin/sshlatex --prefix PATH : "${binPath}"
  '';

  meta = with stdenv.lib; {
    description = "A collection of hacks to efficiently run LaTeX via ssh";
    longDescription = ''
      sshlatex is a tool which uploads LaTeX source files to a remote, runs
      LaTeX there, and streams the resulting PDF file to the local host.
      Because sshlatex prestarts LaTeX with the previous run's preamble,
      thereby preloading the required LaTeX packages, it is also useful in a
      purely local setting.
    '';
    homepage = https://github.com/iblech/sshlatex;
    license = stdenv.lib.licenses.gpl3Plus;  # actually dual-licensed gpl3Plus | lppl13cplus
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.iblech ];
  };
}
