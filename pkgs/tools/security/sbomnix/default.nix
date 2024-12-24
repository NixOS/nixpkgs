{
  lib,
  fetchFromGitHub,
  git,
  grype,
  nix,
  nix-visualize,
  python,
  vulnix,
  # python libs
  beautifulsoup4,
  colorlog,
  dfdiskcache,
  filelock,
  graphviz,
  numpy,
  packageurl-python,
  packaging,
  pandas,
  pyrate-limiter,
  requests,
  requests-cache,
  requests-ratelimiter,
  reuse,
  setuptools,
  tabulate,
}:

python.pkgs.buildPythonApplication rec {
  pname = "sbomnix";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = "sbomnix";
    rev = "refs/tags/v${version}";
    hash = "sha256-LMrsJnJXmn+rneIslAaoIpwOyPVIVjOyu49O+7J/nIs=";

    # Remove documentation as it contains references to nix store
    postFetch = ''
      rm -fr "$out"/doc
      find "$out" -name '*.md' ! -name "README.md" -exec rm -f '{}' \;
    '';
  };

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        nix
        graphviz
        nix-visualize
        vulnix
        grype
      ]
    }"
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    colorlog
    dfdiskcache
    graphviz
    filelock
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

  pythonImportsCheck = [ "sbomnix" ];
  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Utilities to help with software supply chain challenges on nix targets";
    homepage = "https://github.com/tiiuae/sbomnix";
    license = with licenses; [
      asl20
      bsd3
      cc-by-30
    ];
    maintainers = with maintainers; [
      henrirosten
      jk
    ];
  };
}
