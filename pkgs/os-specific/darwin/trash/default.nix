{ stdenv, fetchFromGitHub, perl, cf-private, AppKit, Cocoa, ScriptingBridge }:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "trash-${version}";

  src = fetchFromGitHub {
    owner = "ali-rantakari";
    repo = "trash";
    rev = "v${version}";
    sha256 = "0ylkf7jxfy1pj7i1s48w28kzqjdfd57m2pw0jycsgcj5bkzwll41";
  };

  buildInputs = [
    perl
    Cocoa AppKit ScriptingBridge
    # Neded for OBJC_CLASS_$_NSMutableArray symbols.
    cf-private
  ];

  patches = [ ./trash.diff ];

  buildPhase = ''make all docs'';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    install -m 0755 trash $out/bin
    install -m 0444 trash.1 $out/share/man/man1
  '';

  meta = {
    homepage = https://github.com/ali-rantakari/trash;
    description = "Small command-line program for OS X that moves files or
    folders to the trash.";
    platforms = stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.mit;
  };
}
