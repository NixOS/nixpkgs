{ stdenv, lib, fetchFromGitHub, fetchpatch, ldc, curl, gnumake42 }:

stdenv.mkDerivation rec {
  pname = "dtools";
  version = "2.095.1";

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "tools";
    rev = "v${version}";
    sha256 = "sha256:0rdfk3mh3fjrb0h8pr8skwlq6ac9hdl1fkrkdl7n1fa2806b740b";
    name = "dtools";
  };

  patches = [
    (fetchpatch {
      # part of https://github.com/dlang/tools/pull/441
      url = "https://github.com/dlang/tools/commit/6c6a042d1b08e3ec1790bd07a7f69424625ee866.patch"; # Fix LDC arm64 build
      sha256 = "sha256-x6EclTYN1Y5FG57KLhbBK0BZicSYcZoWO7MTVcP4T18=";
    })
  ];

  nativeBuildInputs = [ ldc gnumake42 ]; # fails with make 4.4
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
