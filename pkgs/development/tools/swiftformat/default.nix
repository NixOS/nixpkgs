{ stdenv, lib, fetchFromGitHub, runCommand }:

# This derivation is impure: it relies on an Xcode toolchain being installed
# and available in the expected place. The values of sandboxProfile and
# hydraPlatforms are copied pretty directly from the MacVim derivation, which
# is also impure.

stdenv.mkDerivation rec {
  pname = "swiftformat";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = "SwiftFormat";
    rev = "${version}";
    sha256 = "13s6syzpxklkv07s1dzdccnqz6p316rrhjpxg8y8dy19ynj5jzvg";
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
    hydraPlatforms = [];
  };
}
