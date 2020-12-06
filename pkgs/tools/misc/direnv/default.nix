{ stdenv, fetchFromGitHub, buildGoModule, bash, fish, zsh }:

buildGoModule rec {
  pname = "direnv";
  version = "2.25.0";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "00bvznswmz08s2jqpz5xxmkqggd06h6g8cwk242aaih6qajxfpsn";
  };

  # we have no bash at the moment for windows
  BASH_PATH =
    stdenv.lib.optionalString (!stdenv.hostPlatform.isWindows)
    "${bash}/bin/bash";

  # fix hardcoded GOFLAGS in makefile. remove once https://github.com/direnv/direnv/issues/718 is closed.
  postPatch = ''
    substituteInPlace GNUmakefile --replace "export GOFLAGS=-mod=vendor" ""
  '';

  # replace the build phase to use the GNUMakefile instead
  buildPhase = ''
    make BASH_PATH=$BASH_PATH
  '';

  installPhase = ''
    make install DESTDIR=$out
    mkdir -p $out/share/fish/vendor_conf.d
    echo "eval ($out/bin/direnv hook fish)" > $out/share/fish/vendor_conf.d/direnv.fish
  '';

  checkInputs = [ fish zsh ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    make test-go test-bash test-fish test-zsh
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
    homepage = "https://direnv.net";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
