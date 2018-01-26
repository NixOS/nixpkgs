{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.078.0";

  srcs = [
    (fetchFromGitHub {
      owner = "dlang";
      repo = "dmd";
      rev = "v${version}";
      sha256 = "1ia4swyq0xqppnpmcalh2yxywdk2gv3kvni2abx1mq6wwqgmwlcr";
      name = "dmd";
    })
    (fetchFromGitHub {
      owner = "dlang";
      repo = "tools";
      rev = "v${version}";
      sha256 = "1cydhn8g0h9i9mygzi80fb5fz3z1f6m8b9gypdvmyhkkzg63kf12";
      name = "dtools";
    })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv dmd dtools
      cd dtools
  '';

  postPatch = ''
      substituteInPlace posix.mak \
          --replace "../dmd/generated/\$(OS)/release/\$(MODEL)/dmd" ${dmd.out}/bin/dmd

      substituteInPlace posix.mak \
          --replace gcc $CC

      # To fix rdmd test with newer phobos
      substituteInPlace rdmd.d \
          --replace " std.stdiobase," ""
  '';

  nativeBuildInputs = [ dmd ];
  buildInputs = [ curl ];

  makeCmd = ''
    make -f posix.mak DMD=${dmd.out}/bin/dmd DMD_DIR=dmd
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
