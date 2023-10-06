{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, Foundation
, CoreGraphics
, Metal
, AppKit
}:

buildGoModule rec {
  pname = "gdlv";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${version}";
    hash = "sha256-OPsQOFwV6jIX4ZOVwJmpTeQUr/zkfkqCr86HmPhYarI=";
  };

  preBuild = lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0") ''
    export MACOSX_DEPLOYMENT_TARGET=10.15
  '';

  vendorHash = null;

  subPackages = ".";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation CoreGraphics Metal AppKit ];

  meta = with lib; {
    description = "GUI frontend for Delve";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.gpl3;
  };
}
