{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
    maintainers = [ ];
  };
})
