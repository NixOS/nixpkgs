{ lib
, stdenv
, fetchFromGitHub
, runCommand
, darwin
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.2.8";
  hash = "sha256-X+JJXv+8EIh0hjYnKkeQ3+XQ6CerHrEvPCok5DYxcwc=";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  ADDFLAGS = with darwin.apple_sdk.frameworks;
    lib.optional stdenv.isDarwin
      "-F${IOKit}/Library/Frameworks/";

  buildInputs = with darwin.apple_sdk;
    lib.optionals stdenv.isDarwin [
      frameworks.CoreFoundation
      frameworks.IOKit
    ];

  makeFlags = [
    "ARCH=${stdenv.targetPlatform.darwinArch or stdenv.targetPlatform.uname.processor}"
    "PLATFORM=${stdenv.targetPlatform.uname.system}"
  ];

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
