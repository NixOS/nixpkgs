{ stdenv, fetchurl, substituteAll, coreutils, python2, python2Packages }:

assert stdenv.isLinux;

python2Packages.buildPythonApplication rec {
  name = "trash-cli-${version}";
  version = "0.12.9.14";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/andreafrancia/trash-cli/archive/${version}.tar.gz";
    sha256 = "10idvzrlppj632pw6mpk1zy9arn1x4lly4d8nfy9cz4zqv06lhvh";
  };


  patches = [
    # Fix paths.
    (substituteAll {
      src = ./nix-paths.patch;
      df = "${coreutils}/bin/df";
      python = "${python2}/bin/${python2.executable}";
      libc = "${stdenv.cc.libc.out}/lib/libc.so.6";
    })

    # Apply https://github.com/JaviMerino/trash-cli/commit/4f45a37a3
    # to fix failing test case.
    ./fix_should_output_info_for_multiple_files.patch
  ];

  buildInputs = with python2Packages; [ nose mock ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://github.com/andreafrancia/trash-cli;
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    license = licenses.gpl2;
  };
}
