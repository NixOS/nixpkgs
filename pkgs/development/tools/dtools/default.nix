{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.084.1";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "10ll5072rkv3ln7i5l88h2f9mzda567kw2jwh6466vm6ylzl4jms";
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
