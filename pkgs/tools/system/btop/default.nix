{ lib
, config
, stdenv
, fetchFromGitHub
, cmake
, darwin
, removeReferencesTo
, btop
, testers
, cudaSupport ? config.cudaSupport
, cudaPackages
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QQM2/LO/EHovhj+S+4x3ro/aOVrtuxteVVvYAd6feTk=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

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
    mainProgram = "btop";
  };
}
