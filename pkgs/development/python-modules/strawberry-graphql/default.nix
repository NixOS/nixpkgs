{ lib, buildPythonPackage, fetchFromGitHub, poetry, pythonOlder
, click, backports-cached-property, graphql-core, pygments, python-dateutil, python-multipart, typing-extensions
, aiohttp, asgiref, chalice, django, fastapi, flask, pydantic, sanic, starlette, uvicorn
}:

buildPythonPackage rec {
  pname = "strawberry-graphql";
  version = "0.125.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = version;
    sha256 = "sha256-8ERmG10qNiYg9Zr8oUZk/Uz68sCE+oWrqmJ5kUMqbRo=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    click backports-cached-property graphql-core pygments python-dateutil python-multipart typing-extensions
    aiohttp asgiref chalice django fastapi flask pydantic sanic starlette uvicorn
  ];

  pythonImportsCheck = [
    "strawberry"
  ];

  meta = with lib; {
    description = "A GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
