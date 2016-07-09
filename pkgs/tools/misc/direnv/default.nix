{ stdenv, fetchFromGitHub, go, bash }:

stdenv.mkDerivation rec {
  name = "direnv-${version}";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "1zi4i2ds8xkbhfcpi52hca4lcwan9gf93bdmd2vwdsry16kn3f6k";
  };

  buildInputs = [ go ];

  buildPhase = ''
    make BASH_PATH=${bash}/bin/bash
  '';

  installPhase = ''
    make install DESTDIR=$out
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
