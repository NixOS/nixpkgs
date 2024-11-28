{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  autoAddDriverRunpath,
  apple-sdk_15,
  darwinMinVersionHook,
  versionCheckHook,
  rocmPackages,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A5hOBxj8tKlkHd8zDHfDoU6fIu8gDpt3/usbiDk0/G0=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals cudaSupport [
      autoAddDriverRunpath
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    (darwinMinVersionHook "10.15")
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  postPhases = lib.optionals rocmSupport [ "postPatchelf" ];
  postPatchelf = lib.optionalString rocmSupport ''
    patchelf --add-rpath ${lib.getLib rocmPackages.rocm-smi}/lib $out/bin/btop
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = with lib; {
    description = "Monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      khaneliman
      rmcgibbo
    ];
    mainProgram = "btop";
  };
}
