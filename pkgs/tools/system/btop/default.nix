{ lib
, stdenv
, fetchFromGitHub
, runCommand
, darwin
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.2.12";
  hash = "sha256-ieNwFCDJF0U1wTfAeWM22CS3RE1SEp12ODHsRVYFoKU=";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  ADDFLAGS = with darwin.apple_sdk.frameworks;
    lib.optional stdenv.isDarwin
      "-F${IOKit}/Library/Frameworks/";

  buildInputs = with darwin.apple_sdk;
    lib.optionals stdenv.isDarwin [
      frameworks.CoreFoundation
      frameworks.IOKit
    ] ++ lib.optional (stdenv.isDarwin && stdenv.isx86_64) (
      # Found this explanation for needing to create a header directory for libproc.h alone.
      # https://github.com/NixOS/nixpkgs/blob/049e5e93af9bbbe06b4c40fd001a4e138ce1d677/pkgs/development/libraries/webkitgtk/default.nix#L154
      # TL;DR, the other headers in the include path for the macOS SDK is not compatible with the C++ stdlib and causes issues, so we copy
      # this to avoid those issues
      runCommand "${pname}_headers" { } ''
        install -Dm444 "${lib.getDev sdk}"/include/libproc.h "$out"/include/libproc.h
      ''
    );

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  meta = with lib; {
    description = "A monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
