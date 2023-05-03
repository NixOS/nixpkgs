{ lib
, aiohttp
, asgiref
, backports-cached-property
, buildPythonPackage
, chalice
, channels
, click
, daphne
, django
, email-validator
, fastapi
, fetchFromGitHub
, fetchpatch
, flask
, freezegun
, graphql-core
, libcst
, mypy
, poetry-core
, pydantic
, pygments
, pyinstrument
, pytest-aiohttp
, pytest-asyncio
, pytest-django
, pytest-emoji
, pytest-flask
, pytest-snapshot
, pytestCheckHook
, python-dateutil
, python-multipart
, pythonOlder
, rich
, sanic
, sanic-testing
, starlette
, typing-extensions
, uvicorn
}:

buildPythonPackage rec {
  pname = "strawberry-graphql";
  version = "0.176.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = "refs/tags/${version}";
    hash = "sha256-e61wLFqc3HLCWUiVW3Gzbay1Oi8b7HsLT3+jPnbA4YY=";
  };

  patches = [
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/strawberry-graphql/strawberry/commit/710bb96f47c244e78fc54c921802bcdb48f5f421.patch";
      hash = "sha256-ekUZ2hDPCqwXp9n0YjBikwSkhCmVKUzQk7LrPECcD7Y=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --emoji --mypy-ini-file=mypy.ini --benchmark-disable" "" \
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    graphql-core
    python-dateutil
    typing-extensions
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
      pytest-aiohttp
    ];
    asgi = [
      starlette
      python-multipart
    ];
    debug = [
      rich
      libcst
    ];
    debug-server = [
      click
      libcst
      pygments
      python-multipart
      rich
      starlette
      uvicorn
    ];
    django = [
      django
      pytest-django
      asgiref
    ];
    channels = [
      channels
      asgiref
    ];
    flask = [
      flask
      pytest-flask
    ];
    # opentelemetry = [
    #   opentelemetry-api
    #   opentelemetry-sdk
    # ];
    pydantic = [
      pydantic
    ];
    sanic = [
      sanic
    ];
    fastapi = [
      fastapi
      python-multipart
    ];
    chalice = [
      chalice
    ];
    cli = [
      click
      pygments
      rich
      libcst
    ];
    # starlite = [
    #   starlite
    # ];
    pyinstrument = [
      pyinstrument
    ];
  };

  nativeCheckInputs = [
    daphne
    email-validator
    freezegun
    mypy
    pytest-asyncio
    pytest-emoji
    pytest-snapshot
    pytestCheckHook
    sanic-testing
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "strawberry"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/cli/"
    "tests/django/test_dataloaders.py"
    "tests/exceptions/"
    "tests/http/"
    "tests/schema/extensions/"
    "tests/schema/test_dataloaders.py"
    "tests/schema/test_lazy/"
    "tests/starlite/"
    "tests/test_dataloaders.py"
    "tests/utils/test_pretty_print.py"
  ];

  meta = with lib; {
    description = "A GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    changelog = "https://github.com/strawberry-graphql/strawberry/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
