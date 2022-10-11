{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  unzip,
  runCommand
}:

# This derivation is impure: it relies on an Xcode toolchain being installed
# and available in the expected place (and is Darwin only). It was copied
# pretty heavily from swiftformat which is different from swift-format.

# swift-format is available as part of the swift (compiler) nixpkg, but that
# doesn't build on Darwin.

let

  versions = {
    swift_format = "0.50700.1";
    swift_argument_parser = "1.1.4";
    swift_tools_support_core = "0.2.7";
    swift_syntax = "0.50700.1";
    swift_system = "1.1.1";
  };

  fetchAppleRepo = { repo, rev, sha256 }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo rev sha256;
      name = "${repo}-${rev}-src";
    };

  sources = {
    swift_format = fetchAppleRepo {
      repo = "swift-format";
      rev = "${versions.swift_format}";
      sha256 = "sha256-AFaViBqfqvk2D2abg4a240hmBTN1zCiWR/DUy+XBp6w=";
    };

    swift_argument_parser = fetchAppleRepo {
      repo = "swift-argument-parser";
      rev = "${versions.swift_argument_parser}";
      sha256 = "sha256-ibNKHxIHJWpafIggyDSChvI15+YnLwsej8B10tm8ZKU";
    };

    swift_tools_support_core = fetchAppleRepo {
      repo = "swift-tools-support-core";
      rev = "${versions.swift_tools_support_core}";
      sha256 = "sha256-thYDNOpdmXUXvPpfG8yO9UVZiWZbdxePUivDJJUdbFE=";
    };

    swift_syntax = fetchAppleRepo {
      repo = "swift-syntax";
      rev = "${versions.swift_syntax}";
      sha256 = "sha256-Y5F2Mi2I+fec0h3L579rmUnsHex3zPYAIB1F1KJdrtM=";
    };

    swift_system = fetchAppleRepo {
      repo = "swift-system";
      rev = "${versions.swift_system}";
      sha256 = "sha256-p18QHzO+NtoY/WQzOD+PfD+bjqrIWsbeEbsJLPqEAhA";
    };

  };

in
stdenv.mkDerivation rec {
  pname = "swift-format";
  version = "${versions.swift_format}";

  unpackPhase = ''
    cp -r ${sources.swift_format} swift-format
    cp -r ${sources.swift_argument_parser} swift-argument-parser
    cp -r ${sources.swift_tools_support_core} swift-tools-support-core
    cp -r ${sources.swift_syntax} swift-syntax
    cp -r ${sources.swift_system} swift-system
    chmod -R +w .
    mkdir -p swift-format/.build
  '';

  preConfigure = "LD=$CC";

  nativeBuildInputs = [ unzip ];
  buildPhase = ''
    cd swift-format
    SWIFTCI_USE_LOCAL_DEPS=1 /usr/bin/swift build --disable-sandbox -c release
  '';

  installPhase = ''
    mkdir -p $out/bin
    install_name_tool -change @rpath/lib_InternalSwiftSyntaxParser.dylib $out/lib_InternalSwiftSyntaxParser.dylib .build/release/swift-format
    install -m 0644 .build/artifacts/swift-syntax/_InternalSwiftSyntaxParser.xcframework/macos-arm64_x86_64/lib_InternalSwiftSyntaxParser.dylib $out/lib_InternalSwiftSyntaxParser.dylib
    install -m 0755 .build/release/swift-format "$out/bin/swift-format"
  '';

  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = "Formatting technology for Swift source code ";
    homepage = "https://github.com/apple/swift-format";
    license = licenses.asl20;
    maintainers = with maintainers; [ scoates ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
