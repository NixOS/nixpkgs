{ stdenv, fetchFromGitHub, fetchpatch, coreutils
, python3Packages, substituteAll }:

python3Packages.buildPythonApplication rec {
  name = "trash-cli-${version}";
  version = "0.17.1.14";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "1bqazna223ibqjwbc1wfvfnspfyrvjy8347qlrgv4cpng72n7gfi";
  };

  patches = [
    (substituteAll {
      src = ./nix-paths.patch;
      df = "${coreutils}/bin/df";
      libc = let ext = if stdenv.isDarwin then ".dylib" else ".so.6";
             in "${stdenv.cc.libc}/lib/libc${ext}";
    })

    # Fix build on Python 3.6.
    (fetchpatch {
      url = "https://github.com/andreafrancia/trash-cli/commit/a21b80d1e69783bb09376c3f60dd2f2a10578805.patch";
      sha256 = "0w49rjh433sjfc2cl5a9wlbr6kcn9f1qg905qsyv7ay3ar75wvyp";
    })

    # Fix listing trashed files over mount points, see https://github.com/andreafrancia/trash-cli/issues/95
    (fetchpatch {
      url = "https://github.com/andreafrancia/trash-cli/commit/436dfddb4c2932ba3ff696e4732750b7bdc58461.patch";
      sha256 = "02pkcz7nj67jbnqpw1943nrv95m8xyjvab4j62fa64r73fagm8m4";
    })
  ];

  checkInputs = with python3Packages; [
    nose
    mock
  ];
  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://github.com/andreafrancia/trash-cli;
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
