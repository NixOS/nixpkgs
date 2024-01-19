{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "swiftlint";
  version = "0.52.4";

  src = fetchzip {
    url = "https://github.com/realm/SwiftLint/releases/download/${version}/SwiftLintBinary-macos.artifactbundle.zip";
    hash = "sha256-MEbWpNfJcAgQVwl0+B1Tf8y7yalYYCr6wG/S+L8a5dM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -m755 -D ./swiftlint-${version}-macos/bin/swiftlint $out/bin/swiftlint
  '';

  meta = with lib; {
    description = "A tool to enforce Swift style and conventions";
    homepage = "https://github.com/realm/SwiftLint";
    license = licenses.mit;
    maintainers = with maintainers; [ rhousand ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
