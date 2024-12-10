{
  lib,
  fetchFromGitHub,
  grype,
  nix,
  nix-visualize,
  python,
  vulnix,
  # python libs
  beautifulsoup4,
  colorlog,
  dfdiskcache,
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
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = "sbomnix";
    rev = "refs/tags/v${version}";
    hash = "sha256-kPjCK9NEs3D0qFsSSVX6MYGKbwqeij0svTfzz5JC4qM=";

    # Remove documentation as it contains references to nix store
    postFetch = ''
      rm -fr "$out"/doc
      find "$out" -name '*.md' ! -name "README.md" -exec rm -f '{}' \;
    '';
  };

  postInstall = ''
    wrapProgram $out/bin/sbomnix \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          graphviz
        ]
      }
    wrapProgram $out/bin/nixgraph \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          graphviz
        ]
      }
    wrapProgram $out/bin/vulnxscan \
      --prefix PATH : ${
        lib.makeBinPath [
          grype
          nix
          vulnix
        ]
      }
    wrapProgram $out/bin/nix_outdated \
      --prefix PATH : ${lib.makeBinPath [ nix-visualize ]}
    wrapProgram $out/bin/provenance \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  nativeBuildInputs = [ setuptools ];

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
