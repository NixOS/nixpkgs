{ stdenv, lib, fetchFromGitHub }:

# This derivation is impure: it relies on Xcode's version of Swift to
# be installed in its expected place.

let version = "5.4";
    swiftFormatVersion = "0.50400.0";
    sources = {
      format = fetchFromGitHub {
        owner = "apple";
        repo = "swift-format";
        rev = "0.50400.0";
        sha256 = "0skmmggsh31f3rnqcrx43178bc7scrjihibnwn68axagasgbqn4k";
      };
      argumentParser = fetchFromGitHub {
        owner = "apple";
        repo = "swift-argument-parser";
        rev = "1.0.1";
        name = "swift-argument-parser-1.0.1";
        sha256 = "070gip241dgn3d0nxgwxva4vp6kbnf11g01q5yaq6kmflcmz58f2";
      };
      syntax = fetchFromGitHub {
        owner = "apple";
        repo = "swift-syntax";
        rev = "swift-${version}-RELEASE";
        sha256 = "02zrimxkily6b4iy7wbwj61w8bd13g060ibbk7z3bpymr3m9lrb4";
      };
    };
in stdenv.mkDerivation rec {
  pname = "swift-format";
  version = "5.4";

  src = sources.format;

  unpackPhase = ''
    mkdir src
    cd src

    export SWIFT_SOURCE_ROOT=$PWD

    cp -r ${sources.format} swift-format
    cp -r ${sources.argumentParser} swift-argument-parser
    cp -r ${sources.syntax} swift-syntax

    chmod -R u+w .
  '';

  configurePhase = ''
    export SWIFT_FORMAT_ROOT=$SWIFT_SOURCE_ROOT/swift-format
  '';

  buildPhase = ''
    cd $SWIFT_FORMAT_ROOT
    SWIFTCI_USE_LOCAL_DEPS=1 /usr/bin/swift build -c release \
      --disable-sandbox \
      --manifest-cache none \
      --disable-build-manifest-caching \
      --disable-repository-cache
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0555 $SWIFT_FORMAT_ROOT/.build/release/swift-format $out/bin/swift-format
  '';

  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = ''
      Provides the formatting technology for SourceKit-LSP and the building blocks
      for doing code formatting transformations.
    '';
    homepage = "https://github.com/apple/swift-format";
    license = licenses.asl20;
    maintainers = [ maintainers.rgnns ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
