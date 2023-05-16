{ stdenv, lib, fetchFromGitHub, fetchpatch, ldc, curl, gnumake42 }:

stdenv.mkDerivation rec {
  pname = "dtools";
<<<<<<< HEAD
  version = "2.103.1";
=======
  version = "2.095.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "tools";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-XM4gUxcarQCOBR8W/o0iWAI54PyLDkH6CsDce22Cnu4=";
=======
    sha256 = "sha256:0rdfk3mh3fjrb0h8pr8skwlq6ac9hdl1fkrkdl7n1fa2806b740b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
