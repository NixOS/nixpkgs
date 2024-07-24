{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, asciidoctor
, installShellFiles
, makeWrapper
, ripgrep
}:

rustPlatform.buildRustPackage rec {
  pname = "repgrep";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-6ba7EJUts0Ni9EA3ENlK+a2FaPo7JohtCyqwR9DdL1E=";
  };

  cargoHash = "sha256-XEjKTZ3qaiLWbm2wF+V97u9tGXDq/oTm249ubUE9n94=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/rgr \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    pushd "$(dirname "$(find -path '**/repgrep-stamp' | head -n 1)")"
    installManPage rgr.1
    popd
  '' + lib.optionalString (stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    # As it can be seen here: https://github.com/acheronfail/repgrep/blob/0.15.0/.github/workflows/release.yml#L206, the completions are just the same as ripgrep
    installShellCompletion --cmd rgr \
      --bash <(${lib.getExe ripgrep} --generate complete-bash | sed 's/-c rg/-c rgr/') \
      --zsh <(${lib.getExe ripgrep} --generate complete-zsh | sed 's/-c rg/-c rgr/') \
      --fish <(${lib.getExe ripgrep} --generate complete-fish | sed 's/-c rg/-c rgr/')
  '';

  meta = with lib; {
    description = "Interactive replacer for ripgrep that makes it easy to find and replace across files on the command line";
    homepage = "https://github.com/acheronfail/repgrep";
    changelog = "https://github.com/acheronfail/repgrep/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 unlicense ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rgr";
  };
}
