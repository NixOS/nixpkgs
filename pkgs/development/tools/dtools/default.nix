{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.084.0";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "1v61spdamncl8c1bzjc19b03p4jl0ih5zq9b7cqsy9ix7qaxmikf";
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
