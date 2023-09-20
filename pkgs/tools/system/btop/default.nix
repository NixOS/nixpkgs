{ lib
, stdenv
, fetchFromGitHub
, darwin
, removeReferencesTo
, btop
, testers
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F/muCjhcnM+VqAn6FlD4lv23OLITrmtnHkFc5zv97yk=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  env.ADDFLAGS = lib.optionalString stdenv.isDarwin
    "-F${darwin.apple_sdk_11_0.frameworks.IOKit}/Library/Frameworks/";

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  passthru.tests.version = testers.testVersion {
    package = btop;
  };

  meta = with lib; {
    description = "A monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
