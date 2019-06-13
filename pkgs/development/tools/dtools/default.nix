{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.085.1";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "0ccidfcawrcwdpfjwjiln5xwr4ffp8i2hwx52p8zn3xmc5yxm660";
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "tools";
      rev = "v${version}";
      sha256 = "1x85w4k2zqgv2bjbvhschxdc6kq8ygp89h499cy8rfqm6q23g0ws";
      name = "dtools";
    })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd dtools
      cd dtools

      substituteInPlace posix.mak --replace "\$(DMD) \$(DFLAGS) -unittest -main -run rdmd.d" ""
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
