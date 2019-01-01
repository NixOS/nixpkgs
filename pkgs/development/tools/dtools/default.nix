{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.083.1";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "0b52yq7slgbrawb22kib9bk2x9xjiy6axwz1317fck5axl093d90";
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "tools";
      rev = "v${version}";
      sha256 = "0z3xkv9s1pdx8zdhsb92mwax2q5xhwjgh6g3iv53xip1nsxygn48";
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
