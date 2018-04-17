{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.079.0";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "1k6cky71pqnss6h6391p1ich2mjs598f5fda018aygnxg87qgh4y";
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "tools";
      rev = "v${version}";
      sha256 = "0fvpfwh3bh3fymrmis3n39x9hkfklmv81lrlqcyl8fmmk694yvad";
      name = "dtools";
    })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd dtools
      cd dtools
  '';

  nativeBuildInputs = [ dmd ];
  buildInputs = [ curl ];

  makeCmd = ''
    make -f posix.mak DMD_DIR=dmd DMD=${dmd.out}/bin/dmd CC=${stdenv.cc}/bin/cc
  '';

  buildPhase = ''
    $makeCmd
  '';

  doCheck = true;

  checkPhase = ''
      $makeCmd test_rdmd
    '';

  installPhase = ''
      $makeCmd INSTALL_DIR=$out install
	'';

  meta = with stdenv.lib; {
    description = "Ancillary tools for the D programming language compiler";
    homepage = https://github.com/dlang/tools;
    license = lib.licenses.boost;
    maintainers = with maintainers; [ ThomasMader ];
    platforms = stdenv.lib.platforms.unix;
  };
}
