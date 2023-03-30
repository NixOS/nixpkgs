{ lib
, python3Packages
, fetchFromGitHub
, python3
, nix-update-script
}:

python3Packages.buildPythonApplication {
  pname = "chatgpt-retrieval-plugin";
  version = "unstable-2023-03-28";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "chatgpt-retrieval-plugin";
    rev = "958bb787bf34823538482a9eb3157c5bf994a182";
    hash = "sha256-fCNGzK5Uji6wGDTEwAf4FF/i+RC7ny3v4AsvQwIbehY=";
  };

  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python-dotenv = "^0.21.1"' 'python-dotenv = "*"' \
      --replace 'python-multipart = "^0.0.6"' 'python-multipart = "^0.0.5"' \
      --replace 'tiktoken = "^0.2.0"' 'tiktoken = "^0.3.0"'
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];


  propagatedBuildInputs = with python3.pkgs; [
    fastapi
    arrow
    tiktoken
    python-multipart
    python-dotenv
    openai
    weaviate-client
    pinecone-client
    pymilvus
    uvicorn
    python-pptx
    tenacity
    pypdf2
    qdrant-client
    redis
    docx2txt
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/openai/chatgpt-retrieval-plugin";
    description = "The ChatGPT Retrieval Plugin lets you easily search and find personal or work documents by asking questions in everyday language. ";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
