{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "ttconv";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sandflow";
    repo = "ttconv";
    tag = finalAttrs.version;
    hash = "sha256-2kBEkDX612+H6W0BdtlDScgsgXl/sHRi+jo1vDxTJ7k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ttconv" ];

  # No version is embedded, but we still check if the executable can run
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/tt -h

    runHook postInstallCheck
  '';

  __structuredAttrs = true;

  meta = {
    description = "Timed Text Conversion";
    longDescription = ''
      A library and command line application written in pure Python
      for converting between timed text formats
      used in the presentations of captions, subtitles, karaoke, etc.
    '';
    homepage = "https://github.com/sandflow/ttconv";
    changelog = "https://github.com/sandflow/ttconv/releases/tag/${finalAttrs.version}";
    mainProgram = "tt";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sfrijters ];
  };
})
