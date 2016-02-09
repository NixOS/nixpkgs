{ stdenv, fetchurl }:

let version = "2.6.7"; in
stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";

  src = fetchurl {
    url = "http://ftpmain.gnustep.org/pub/gnustep/core/${name}.tar.gz";
    sha256 = "1r2is23xdg4qirckb6bd4lynfwnnw5d9522wib3ndk1xgirmfaqi";
  };

  patchPhase = ''
    substituteInPlace GNUmakefile.in \
      --replace which type \
      --replace 'tooldir = $(DESTDIR)' 'tooldir = ' \
      --replace 'makedir = $(DESTDIR)' 'makedir = ' \
      --replace 'mandir  = $(DESTDIR)' 'mandir  = '

    substituteInPlace FilesystemLayouts/apple \
      --replace /usr/local ""

    substituteInPlace configure \
      --replace /Library/GNUstep "$out"
  '';

  installFlags = "DESTDIR=$(out)";

  postInstall = ''
    mkdir -p $out/nix-support
    cat >$out/nix-support/setup-hook <<EOF
      . $out/Library/GNUstep/Makefiles/GNUstep.sh
    EOF
  '';
}
