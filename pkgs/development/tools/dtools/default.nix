{stdenv, lib, fetchFromGitHub, ldc, curl}:

stdenv.mkDerivation rec {
  pname = "dtools";
  version = "2.095.1";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "sha256:0faca1y42a1h16aml4lb7z118mh9k9fjx3xlw3ki5f1h3ln91xhk";
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "tools";
      rev = "v${version}";
      sha256 = "sha256:0rdfk3mh3fjrb0h8pr8skwlq6ac9hdl1fkrkdl7n1fa2806b740b";
      name = "dtools";
    })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd dtools
      cd dtools

  '';

  nativeBuildInputs = [ ldc ];
  buildInputs = [ curl ];

  makeCmd = ''
    make -f posix.mak all DMD_DIR=dmd DMD=${ldc.out}/bin/ldmd2 CC=${stdenv.cc}/bin/cc
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

  meta = with lib; {
    description = "Ancillary tools for the D programming language compiler";
    homepage = "https://github.com/dlang/tools";
    license = lib.licenses.boost;
    maintainers = with maintainers; [ ThomasMader ];
    platforms = lib.platforms.unix;
  };
}
