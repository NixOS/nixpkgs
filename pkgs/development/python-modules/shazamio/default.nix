{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  wheel,
  aiofiles,
  aiohttp,
  adaptix,
  numpy,
  pydantic,
  pydub,
  ffmpeg,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "shazamio";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dotX12";
    repo = "ShazamIO";
    tag = finalAttrs.version;
    hash = "sha256-beEEr9Y8w0XlC/0+mNL/oWscmnfwt9KChlZ7Ullyk3E=";
  };

  patches = [
    # fixes the version 0.8.0 -> 0.8.1 in the pyproject file
    (fetchpatch {
      url = "https://github.com/tomasriveral/ShazamIO/commit/23dd6f2b4195616cbfa5dd98339265e4e5959be6.patch";
      hash = "sha256-h7fVAiUJVJk/gItUsyUyDz2q9++UzRoga7NG/IL+MIY=";
    })
    # renames all the occurances of dataclass-factory to adaptix
    (fetchpatch {
      url = "https://github.com/tomasriveral/ShazamIO/commit/cd448fd8736cc47841fc566b0007304189b95490.patch";
      hash = "sha256-2qJM3kynMnZtNTPRXdpgqBv0qo88He61/Sc1a14fstM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    wheel
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    adaptix
    numpy
    pydantic
    pydub
  ];

  nativeCheckInputs = [
    ffmpeg
    pytest-asyncio
    pytestCheckHook
  ];


  /*
  pythonRuntimeDepsCheckHook has a lot of false positives.
  */
  pythonRemoveDeps = [
    "adaptix"
    "aiofiles"
    "aiohttp-retry"
    "anyio"
    "dataclass-factory"
    "shazamio-core"
  ];

  disabledTests = [
    # requires internet access
    "test_about_artist"
    "test_recognize_song_file"
    "test_recognize_song_bytes"
  ];

  pythonImportsCheck = [ "shazamio" ];

  meta = {
    description = "Free asynchronous library from reverse engineered Shazam API";
    homepage = "https://github.com/dotX12/ShazamIO";
    changelog = "https://github.com/dotX12/ShazamIO/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
