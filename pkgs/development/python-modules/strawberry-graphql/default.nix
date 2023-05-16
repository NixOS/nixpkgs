{ lib
, aiohttp
, asgiref
<<<<<<< HEAD
=======
, backports-cached-property
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, opentelemetry-api
, opentelemetry-sdk
=======
, mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, pydantic
, pygments
, pyinstrument
, pytest-aiohttp
, pytest-asyncio
, pytest-django
, pytest-emoji
, pytest-flask
, pytest-mock
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
<<<<<<< HEAD
  version = "0.205.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.176.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-58pBsTQM3t5rj4AywhMqmCUzUQB4BH9FAF7J3p6Qkok=";
=======
    hash = "sha256-O57gCJiLlR3k45V6cRNd9AHo9EGoWd7WRMmnV/8xFyQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (fetchpatch {
<<<<<<< HEAD
      # https://github.com/strawberry-graphql/strawberry/pull/2199
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/strawberry-graphql/strawberry/commit/710bb96f47c244e78fc54c921802bcdb48f5f421.patch";
      hash = "sha256-ekUZ2hDPCqwXp9n0YjBikwSkhCmVKUzQk7LrPECcD7Y=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace "--emoji --mypy-ini-file=mypy.ini" "" \
=======
      --replace " --emoji --mypy-ini-file=mypy.ini --benchmark-disable" "" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    opentelemetry = [
      opentelemetry-api
      opentelemetry-sdk
    ];
=======
    # opentelemetry = [
    #   opentelemetry-api
    #   opentelemetry-sdk
    # ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-asyncio
    pytest-emoji
    pytest-mock
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
<<<<<<< HEAD
    "tests/mypy/test_plugin.py" # avoid dependency on mypy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "tests/schema/extensions/"
    "tests/schema/test_dataloaders.py"
    "tests/schema/test_lazy/"
    "tests/starlite/"
    "tests/test_dataloaders.py"
    "tests/utils/test_pretty_print.py"
<<<<<<< HEAD
    "tests/websockets/test_graphql_transport_ws.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "A GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    changelog = "https://github.com/strawberry-graphql/strawberry/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
