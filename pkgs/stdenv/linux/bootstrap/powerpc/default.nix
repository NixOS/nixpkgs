let
  fetch = { file, sha256 }:
    let
      nixFetchurl = import <nix/fetchurl.nix>;
      args = {
        url = "file://${builtins.toString ./.}/${file}";
        inherit sha256;
        executable = true;
      };
    in if (builtins.functionArgs nixFetchurl) ? executable
      then nixFetchurl args
      else derivation {
        name = file;
        builder = "/bin/sh";

        system = builtins.currentSystem;

        args = [ "-c" "echo $message; exit 1" ];

        message = ''
          Sorry, this version of nix cannot download all of the bootstrap tools.
          Please download ${args.url}, make it executable, add it to the store
          with `nix-store --add', and try again.
        '';

        outputHashAlgo = "sha256";

        outputHash = args.sha256;

        outputHashMode = "recursive";

        preferLocalBuild = true;
      };
in {
  bash = fetch {
    file = "bash";
    sha256 = "0zss8im6hbx6z2i2wxn1554kd7ggdqdli4xk39cy5fchlnz9bqpp";
  };

  bzip2 = fetch {
    file = "bzip2";
    sha256 = "01ylj8x7albv6k9sqx2h1prsazh4d8y22nga0pwai2bnns0q9qdg";
  };

  cp = fetch {
    file = "cp";
    sha256 = "0d7xbzrv22bxgw7w9b03rakirna5zfvr9gzwm7ichd2fh634hvgl";
  };

  curl = fetch {
    file = "curl.bz2";
    sha256 = "17c25dfslw3qkjlcmihpbhn3x4kj9pgkslizv89ggnki7iiy4jgh";
  };

  tar = fetch {
    file = "tar.bz2";
    sha256 = "132ylqwz02hw5njqx7wvj4sxpcrllx8b8b3a00rlv6iad671ayyr";
  };

  staticToolsURL = {
    url = http://nixos.org/tarballs/stdenv-linux/powerpc/r9828/static-tools.tar.bz2;
    sha1 = "e4d1680e3dfa752e49a996a31140db53b10061cb";
  };

  binutilsURL = {
    url = http://nixos.org/tarballs/stdenv-linux/powerpc/r9828/binutils.tar.bz2;
    sha1 = "2609f4d9277a60fcd178395d3d49911190e08f36";
  };

  gccURL = {
    url = http://nixos.org/tarballs/stdenv-linux/powerpc/r9828/gcc.tar.bz2;
    sha1 = "71d79d736bfef6252208fe6239e528a591becbed";
  };

  glibcURL = {
    url = http://nixos.org/tarballs/stdenv-linux/powerpc/r9828/glibc.tar.bz2;
    sha1 = "bf0245e16235800c8aa9c6a5de6565583a66e46d";
  };
}
