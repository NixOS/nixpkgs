{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.6.tar.gz";
    sha256 = "07cqr8x17bia9w6clbmiv7ay6r9nplrjz2cyzinv4w7zfpc19vxw";
  };

  patchPhase = ''
    substituteInPlace GNUmakefile.in \
      --replace which type

    substituteInPlace FilesystemLayouts/apple \
      --replace /usr/local ""
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/nix-support
    cat >$out/nix-support/setup-hook <<EOF
      . $out/Library/GNUstep/Makefiles/GNUstep.sh
    EOF
  '';
}
