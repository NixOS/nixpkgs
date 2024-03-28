{
  lib,
  fetchFromGitHub,
  grype,
  nix,
  python,
  vulnix,
  # python libs
  beautifulsoup4,
  binaryornot,
  boolean-py,
  colorlog,
  dataproperty,
  debian,
  graphviz,
  jinja2,
  license-expression,
  matplotlib,
  mbstrdecoder,
  numpy,
  networkx,
  packageurl-python,
  packaging,
  pandas,
  pathvalidate,
  poetry-core,
  pygraphviz,
  requests,
  requests-cache,
  reuse,
  tabledata,
  tabulate,
  typepy,
  typing-extensions
}:
python.pkgs.buildPythonApplication rec {
  pname = "sbomnix";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = "sbomnix";
    rev = "refs/tags/v${version}";
    hash = "sha256-kPjCK9NEs3D0qFsSSVX6MYGKbwqeij0svTfzz5JC4qM=";

    postFetch = ''
      rm -fr "$out"/doc
      find "$out" -name '*.md' ! -name "README.md" -exec rm -f '{}' \;
    '';
  };

  postInstall = ''

    wrapProgram $out/bin/sbomnix \
        --prefix PATH : ${lib.makeBinPath [nix graphviz]}

    wrapProgram $out/bin/nixgraph \
        --prefix PATH : ${lib.makeBinPath [nix graphviz]}

    wrapProgram $out/bin/vulnxscan \
        --prefix PATH : ${lib.makeBinPath [grype nix vulnix-patched]}

    wrapProgram $out/bin/nix_outdated \
        --prefix PATH : ${lib.makeBinPath [nix-visualize]}

    wrapProgram $out/bin/provenance \
        --prefix PATH : ${lib.makeBinPath [nix]}

  '';

  # We need to patch vulnix to add support for runtime-only scan
  # ('-C' command-line option) which is currently not available in
  # released version of vulnix.
  # Pending: https://github.com/nix-community/vulnix/pull/80.
  vulnix-patched = vulnix.overrideAttrs (
    old: rec {
      patches = (old.patches or []) ++ [
        ./patches/vulnix/0001-remove-unused-function-parameter.patch
        ./patches/vulnix/0002-add-flag-to-scan-only-runtime-dependencies-store-out.patch
        ./patches/vulnix/0003-rename-runtime-to-closure.patch
        ./patches/vulnix/0004-add-shorthand-C-for-closure.patch
        ./patches/vulnix/0005-improve-comment.patch
        ./patches/vulnix/0006-fix-failure-to-find-deriver-for-derivation-input-sou.patch
        ./patches/vulnix/0007-avoid-unnecessary-nix-invocation-during-closure-scan.patch
      ];
    }
  );

  # https://github.com/craigmbooth/nix-visualize (not available in nixpkgs)
  nix-visualize = python.pkgs.buildPythonApplication {
    version = "1.0.5";
    pname = "nix-visualize";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "craigmbooth";
      repo = "nix-visualize";
      rev = "5b9beae330ac940df56433d347494505e2038904";
      hash = "sha256-VgEsR/Odddc7v6oq2tNcVwCYm08PhiqhZJueuEYCR0o=";
    };

    propagatedBuildInputs = [
      matplotlib
      networkx
      pygraphviz
      pandas
    ];
  };

  # https://github.com/thombashi/df-diskcache (not available in nixpkgs)
  dfdiskcache = python.pkgs.buildPythonPackage rec {
    version = "0.0.2";
    pname = "df-diskcache";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "thombashi";
      repo = "df-diskcache";
      rev = "v${version}";
      hash = "sha256-s+sqEPXw6tbEz9mnG+qeUSF6BmDssYhaDYOmraFaRbw=";
    };

    propagatedBuildInputs = [
      pandas
      simplesqlite
      typing-extensions
    ];

    pythonImportsCheck = ["dfdiskcache"];
    doCheck = false;
  };

  # requests-ratelimiter currently does not support pyrate-limiter v3.
  # Pending: https://github.com/JWCook/requests-ratelimiter/issues/78.
  pyrate-limiter = python.pkgs.buildPythonPackage rec {
    version = "2.10.0";
    pname = "pyrate-limiter";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "vutran1710";
      repo = "PyrateLimiter";
      rev = "v${version}";
      hash = "sha256-CPusPeyTS+QyWiMHsU0ii9ZxPuizsqv0wQy3uicrDw0=";
    };

    propagatedBuildInputs = [
      poetry-core
    ];

    doCheck = false;
   };

  # requests-ratelimiter currently does not support pyrate-limiter v3.
  # Pending: https://github.com/JWCook/requests-ratelimiter/issues/78.
  requests-ratelimiter = python.pkgs.buildPythonPackage rec {
    version = "0.4.0";
    pname = "requests-ratelimiter";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "JWCook";
      repo = "requests-ratelimiter";
      rev = "v${version}";
      hash = "sha256-F9bfcwijyyKzlFKBJAC/5ETc4/hZpPhm2Flckku2z6M=";
    };

    propagatedBuildInputs = [
      pyrate-limiter
      requests
    ];

    pythonImportsCheck = ["requests_ratelimiter"];
    doCheck = false;
   };

  # reuse is imported by sbomnix. For this to work with a python.withPackages,
  # reuse needs to be a buildPythonPackage, not buildPythonApplication.
  reuse = python.pkgs.buildPythonPackage rec {
    pname = "reuse";
    version = "2.1.0";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "fsfe";
      repo = "reuse-tool";
      rev = "refs/tags/v${version}";
      hash = "sha256-MEQiuBxe/ctHlAnmLhQY4QH62uAcHb7CGfZz+iZCRSk=";
    };

    nativeBuildInputs = [
      poetry-core
    ];

    propagatedBuildInputs = [
      binaryornot
      boolean-py
      debian
      jinja2
      license-expression
    ];

    pythonImportsCheck = ["reuse"];
    doCheck = false;
  };

  # Required due to dfdiskcache (not available in nixpkgs)
  simplesqlite = python.pkgs.buildPythonPackage rec {
    version = "1.5.2";
    pname = "SimpleSQLite";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "thombashi";
      repo = "SimpleSQLite";
      rev = "v${version}";
      hash = "sha256-Yr17T0/EwVaOjG+mzdxopivj0fuvQdZdX1bFj8vq0MM=";
    };

    propagatedBuildInputs = [
      dataproperty
      mbstrdecoder
      pathvalidate
      sqliteschema
      tabledata
      typepy
    ];

    pythonImportsCheck = ["simplesqlite"];
    doCheck = false;
  };

  # Required due to dfdiskcache (not available in nixpkgs)
  sqliteschema = python.pkgs.buildPythonPackage rec {
    version = "1.4.0";
    pname = "sqliteschema";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "thombashi";
      repo = "sqliteschema";
      rev = "v${version}";
      hash = "sha256-IzHdYBnh6udVsanWTPSsX4p4PG934YCdzs9Ow/NW86E=";
    };

    propagatedBuildInputs = [
      mbstrdecoder
      tabledata
      typepy
    ];

    pythonImportsCheck = ["sqliteschema"];
    doCheck = false;
  };

  propagatedBuildInputs = [
    beautifulsoup4
    colorlog
    dfdiskcache
    graphviz
    numpy
    packageurl-python
    packaging
    pandas
    pyrate-limiter
    requests
    requests-cache
    requests-ratelimiter
    reuse
    tabulate
  ];

  pythonImportsCheck = ["sbomnix"];
  doCheck = false;

  meta = with lib; {
    description = "Utilities to help with software supply chain challenges on nix targets";
    homepage = "https://github.com/tiiuae/sbomnix";
    license = with licenses; [asl20 bsd3 cc-by-30];
    maintainers = with maintainers; [henrirosten jk];
  };
}
