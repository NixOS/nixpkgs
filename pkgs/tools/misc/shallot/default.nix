{ lib, stdenv, fetchFromGitHub, fetchpatch
, openssl
}:

stdenv.mkDerivation rec {
  pname = "shallot";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "katmagic";
    repo = "Shallot";
    rev = "shallot-${version}";
    sha256 = "0cjafdxvjkwb9vyifhh11mw0la7yfqswqwqmrfp1fy9jl7m0il9k";
  };

  buildInputs = [ openssl ];

  patches = [
    (fetchpatch {
      url = "https://github.com/katmagic/Shallot/commit/c913088dfaaaf249494514f20a62f2a17b5c6606.patch";
      sha256 = "19l1ppbxpdb0736f7plhybj08wh6rqk1lr3bxsp8jpzpnkh114b2";
    })
    (fetchpatch {
      url = "https://github.com/katmagic/Shallot/commit/cd6628d97b981325e700a38f408a43df426fd569.patch";
      sha256 = "1gaffp5wp1l5p2qdk0ix3i5fhzpx4xphl0haa6ajhqn8db7hbr9y";
    })
    (fetchpatch {
      url = "https://github.com/katmagic/Shallot/commit/5c7c1ccecbbad5a121c50ba7153cbbee7ee0ebf9.patch";
      sha256 = "1zmll4iqz39zwk8vj40n1dpvyq3403l64p2127gsjgh2l2v91s4k";
    })
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: src/shallot.o:(.bss+0x8): multiple definition of `lucky_thread'; src/error.o:(.bss+0x8): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installPhase = ''
    mkdir -p $out/bin
    cp ./shallot $out/bin/
  '';

  meta = {
    description = "Allows you to create customized .onion addresses for your hidden service";

    license = lib.licenses.mit;
    homepage = "https://github.com/katmagic/Shallot";
    platforms = lib.platforms.linux;
  };
}
