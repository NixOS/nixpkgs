{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses }:

stdenv.mkDerivation rec {
  pname = "torrent7z";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "BubblesInTheTub";
    repo = pname;
    rev = version;
    sha256 = "Y2tr0+z9uij4Ifi6FfWRN24BwcDXUZKVLkLtKUiVjU4=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc10-compilation.patch"; # Fix compilation on GCC 10. This patch is included on the latest commit
      url =
        "https://github.com/paulyc/torrent7z/commit/5958f42a364c430b3ed4ac68911bbbea1f967fc4.patch";
      sha256 = "vJOv1sG9XwTvvxQiWew0H5ALoUb9wIAouzTsTvKHuPI=";
    })
  ];

  buildInputs = [ ncurses ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    # Remove non-free RAR source code
    # (see DOC/License.txt, https://fedoraproject.org/wiki/Licensing:Unrar)
    rm -r linux_src/p7zip_4.65/CPP/7zip/Compress/Rar*
    find . -name makefile'*' -exec sed -i '/Rar/d' {} +
  '';

  preConfigure = ''
    mkdir linux_src/p7zip_4.65/bin
    cd linux_src/p7zip_4.65/CPP/7zip/Bundles/Alone
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ../../../../bin/t7z $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/BubblesInTheTub/torrent7z";
    description = "Fork of torrent7z, viz a derivative of 7zip that produces invariant .7z archives for torrenting";
    platforms = platforms.linux;
    maintainers = with maintainers; [ cirno-999 ];
    mainProgram = "t7z";
    # RAR code is under non-free UnRAR license, but we remove it
    license = licenses.gpl3Only;
  };
}
