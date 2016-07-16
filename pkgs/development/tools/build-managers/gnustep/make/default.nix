{ stdenv, fetchurl }:

let version = "2.6.8"; in
stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";

  src = fetchurl {
    url = "http://ftpmain.gnustep.org/pub/gnustep/core/${name}.tar.gz";
    sha256 = "0r00439f7vrggdwv60n8p626gnyymhq968i5x9ad2i4v6g8x4gk0";
  };

  patchPhase = ''
    substituteInPlace GNUmakefile.in \
      --replace which type \
      --replace 'tooldir = $(DESTDIR)' 'tooldir = ' \
      --replace 'makedir = $(DESTDIR)' 'makedir = ' \
      --replace 'mandir  = $(DESTDIR)' 'mandir  = '

    substituteInPlace configure \
      --replace /Library/GNUstep "$out"

  '' + stdenv.lib.optionalString stdenv.isDarwin ''

    substituteInPlace FilesystemLayouts/apple \
      --replace /usr/local ""

  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''

    substituteInPlace FilesystemLayouts/fhs \
      --replace /usr/local "."

  '';

  installFlags = "DESTDIR=$(out)";

  configureFlags =
    if stdenv.isLinux then [ "--with-layout=fhs" ]
    else [ "--with-layout=apple" ];

  postInstall = ''
    mkdir -p $out/nix-support

  '' + stdenv.lib.optionalString stdenv.isDarwin ''

    cat >$out/nix-support/setup-hook <<EOF
      . $out/Library/GNUstep/Makefiles/GNUstep.sh
    EOF

  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''

    cat >$out/nix-support/setup-hook <<EOF
      . $out/share/GNUstep/Makefiles/GNUstep.sh
    EOF

  '';
}
