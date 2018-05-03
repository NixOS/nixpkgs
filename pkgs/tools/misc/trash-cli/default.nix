{ stdenv, fetchFromGitHub, fetchpatch, python3, python3Packages
, lib, makeWrapper, coreutils }:

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
    # Fix build on Python 3.6.
    (fetchpatch {
      url = "https://github.com/andreafrancia/trash-cli/commit/a21b80d1e69783bb09376c3f60dd2f2a10578805.patch";
      sha256 = "0w49rjh433sjfc2cl5a9wlbr6kcn9f1qg905qsyv7ay3ar75wvyp";
    })
  ];

  buildInputs = with python3Packages; [ nose mock ];
  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    for bin in $out/bin/*; do
      wrapProgram $bin \
        --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
        --prefix DYLD_LIBRARY_PATH : ${lib.makeSearchPath "lib" (lib.optional (stdenv.hostPlatform.libc == "glibc") (lib.getDev stdenv.cc.libc))}
    done
  '';

  checkPhase = "nosetests";

  meta = with lib; {
    homepage = https://github.com/andreafrancia/trash-cli;
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
