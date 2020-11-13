{ stdenv, fetchFromGitHub, fetchpatch, coreutils
, python3Packages, substituteAll }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.20.11.7";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "0083vagy0jkahb5sw1il7r53ggk45zbjwwjsqd76v7ph3v1awf4v";
  };

  patches = [
    (substituteAll {
      src = ./nix-paths.patch;
      df = "${coreutils}/bin/df";
      libc = let ext = if stdenv.isDarwin then ".dylib" else ".so.6";
             in "${stdenv.cc.libc}/lib/libc${ext}";
    })
  ];

  checkInputs = with python3Packages; [
    nose
    mock
  ];
  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
