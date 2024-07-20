{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  wheel,
  aiofiles,
  aiohttp,
  dataclass-factory,
  numpy,
  pydantic,
  pydub,
  ffmpeg,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shazamio";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dotX12";
    repo = "ShazamIO";
    rev = "refs/tags/${version}";
    hash = "sha256-nzKvEoh1DrZegoRNqOCh9Qm+7B7uQ9dEH75mVueGxZI=";
  };

  patches = [
    # remove poetry and virtualenv from build dependencies as they are not used
    # https://github.com/dotX12/ShazamIO/pull/71
    (fetchpatch {
      name = "remove-unused-build-dependencies.patch";
      url = "https://github.com/dotX12/ShazamIO/commit/5c61e1efe51c2826852da5b6aa6ad8ce3d4012a9.patch";
      hash = "sha256-KiU5RVBPnSs5qrReFeTe9ePg1fR7y0NchIIHcQwlPaI=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    wheel
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    dataclass-factory
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

  meta = with lib; {
    description = "Free asynchronous library from reverse engineered Shazam API";
    homepage = "https://github.com/dotX12/ShazamIO";
    changelog = "https://github.com/dotX12/ShazamIO/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    # https://github.com/shazamio/ShazamIO/issues/80
    broken = versionAtLeast pydantic.version "2";
  };
}
