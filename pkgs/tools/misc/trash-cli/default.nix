{ stdenv, fetchFromGitHub, fetchpatch, coreutils
, python3, python3Packages, substituteAll }:

assert stdenv.isLinux;

python3Packages.buildPythonApplication rec {
  name = "trash-cli-${version}";
  version = "0.17.1.14";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = "${version}";
    sha256 = "1bqazna223ibqjwbc1wfvfnspfyrvjy8347qlrgv4cpng72n7gfi";
  };

  patches = [
    (substituteAll {
      src = ./nix-paths.patch;
      df = "${coreutils}/bin/df";
      libc = "${stdenv.cc.libc.out}/lib/libc.so.6";
    })

    # Fix build on Python 3.6.
    (fetchpatch {
      url = "https://github.com/andreafrancia/trash-cli/commit/a21b80d1e69783bb09376c3f60dd2f2a10578805.patch";
      sha256 = "0w49rjh433sjfc2cl5a9wlbr6kcn9f1qg905qsyv7ay3ar75wvyp";
    })
  ];

  buildInputs = with python3Packages; [ nose mock ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://github.com/andreafrancia/trash-cli;
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
