{ stdenv, fetchFromGitHub, buildGoModule, bash }:

buildGoModule rec {
  pname = "direnv";
  version = "2.21.3";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "1adi6ld9g4zgz0f6q0kkzrywclqrmikyp7yh22zm9lfdvd5hs8wp";
  };

  # we have no bash at the moment for windows
  BASH_PATH =
    stdenv.lib.optionalString (!stdenv.hostPlatform.isWindows)
    "${bash}/bin/bash";

  # replace the build phase to use the GNUMakefile instead
  buildPhase = ''
    make BASH_PATH=$BASH_PATH
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
    homepage = "https://direnv.net";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
