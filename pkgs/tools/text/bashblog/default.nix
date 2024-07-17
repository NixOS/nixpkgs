{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  substituteAll,
  perlPackages,
  # Flags to enable processors
  # Currently, Markdown.pl does not work
  usePandoc ? true,
  pandoc,
}:

let
  inherit (perlPackages) TextMarkdown;
  # As bashblog supports various markdown processors
  # we can set flags to enable a certain processor
  markdownpl_path = "${perlPackages.TextMarkdown}/bin/Markdown.pl";
  pandoc_path = "${pandoc}/bin/pandoc";

in
stdenv.mkDerivation {
  pname = "bashblog";
  version = "unstable-2022-03-26";

  src = fetchFromGitHub {
    owner = "cfenollosa";
    repo = "bashblog";
    rev = "c3d4cc1d905560ecfefce911c319469f7a7ff8a8";
    sha256 = "sha256-THlP/JuaZzDq9QctidwLRiUVFxRhGNhRKleWbQiqsgg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ TextMarkdown ] ++ lib.optionals usePandoc [ pandoc ];

  patches = [
    (substituteAll {
      src = ./0001-Setting-markdown_bin.patch;
      markdown_path = if usePandoc then pandoc_path else markdownpl_path;
    })
  ];

  postPatch = ''
    patchShebangs bb.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bb.sh $out/bin/bashblog

    runHook postInstall
  '';

  meta = with lib; {
    description = "A single Bash script to create blogs";
    mainProgram = "bashblog";
    homepage = "https://github.com/cfenollosa/bashblog";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
