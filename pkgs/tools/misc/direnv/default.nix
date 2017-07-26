{ stdenv, fetchFromGitHub, go, bash, writeText}:

stdenv.mkDerivation rec {
  name = "direnv-${version}";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "04b098i8dlr6frks67ik0kbc281c6j8lkb6v0y33iwqv45n233q3";
  };

  buildInputs = [ go ];

  buildPhase = ''
    make BASH_PATH=${bash}/bin/bash
  '';

  installPhase = ''
    make install DESTDIR=$out
    mkdir -p $out/share/fish/vendor_conf.d
    echo "eval ($out/bin/direnv hook fish)" > $out/share/fish/vendor_conf.d/direnv.fish
  '';

  meta = with stdenv.lib; {
    description = "A shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = http://direnv.net;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    inherit (go.meta) platforms;
  };
}
