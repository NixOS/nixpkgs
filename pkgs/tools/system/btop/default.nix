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
, rocmSupport ? config.rocmSupport
, rocmPackages
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kjSyIgLTObTOKMG5dk49XmWPXZpCWbLdpkmAsJcFliA=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddDriverRunpath
  ] ++ lib.optional rocmSupport makeWrapper;

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '' + lib.optionalString rocmSupport ''
    wrapProgram $out/bin/btop \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ rocmPackages.rocm-smi ]}"
  '';

  postPhases = lib.optionals rocmSupport [ "postPatchelf" ];
  postPatchelf = lib.optionalString rocmSupport ''
    patchelf --add-rpath ${lib.getLib rocmPackages.rocm-smi}/lib $out/bin/btop
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
