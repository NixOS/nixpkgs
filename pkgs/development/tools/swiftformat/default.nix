{
  stdenv,
  lib,
  fetchFromGitHub,
  runCommand,
}:

# This derivation is impure: it relies on an Xcode toolchain being installed
# and available in the expected place. The values of sandboxProfile and
# hydraPlatforms are copied pretty directly from the MacVim derivation, which
# is also impure.

stdenv.mkDerivation rec {
  pname = "swiftformat";
  version = "0.47.10";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    rev = version;
    sha256 = "1gqxpymbhpmap0i2blg9akarlql4mkzv45l4i212gsxcs991b939";
  };

  preConfigure = "LD=$CC";

  buildPhase = ''
    /usr/bin/xcodebuild -project SwiftFormat.xcodeproj \
      -scheme "SwiftFormat (Command Line Tool)" \
      CODE_SIGN_IDENTITY= SYMROOT=build OBJROOT=build
  '';

  installPhase = ''
    install -D -m 0555 build/Release/swiftformat $out/bin/swiftformat
  '';

  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = "A code formatting and linting tool for Swift";
    homepage = "https://github.com/nicklockwood/SwiftFormat";
    license = licenses.mit;
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.darwin;
    hydraPlatforms = [ ];
  };
}
