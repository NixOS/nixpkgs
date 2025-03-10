{ lib
, buildPythonPackage
, fetchFromGitHub
, # build-system
  setuptools
, setuptools-scm
, packaging
, numpy
, torch
, bitsandbytes
,
}:

buildPythonPackage rec {
  pname = "unsloth";
  version = "2025-02-v2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unslothai";
    repo = "unsloth";
    tag = "${version}";
    sha256 = "sha256-Z6plMoaay5SU2AlU68T7F7C9i8Zr12C+rNA0BHH1dQ0=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [ setuptools-scm ];

  dependencies = [
    packaging
    numpy
    torch
    bitsandbytes
  ];

  # doCheck = true;

  meta = with lib; {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory!";
    homepage = "https://github.com/unslothai/unsloth";
    license = licenses.mit;
    maintainers = with maintainers; [ hoh ];
  };
}

