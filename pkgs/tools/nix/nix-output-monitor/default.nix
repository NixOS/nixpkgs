# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
{
  mkDerivation,
  ansi-terminal,
  async,
  attoparsec,
  base,
  bytestring,
  cassava,
  containers,
  data-default,
  directory,
  expect,
  extra,
  fetchzip,
  filepath,
  generic-optics,
  HUnit,
  installShellFiles,
  lib,
  lock-file,
  MemoTrie,
  mtl,
  nix-derivation,
  optics,
  process,
  random,
  relude,
  runtimeShell,
  safe,
  stm,
  streamly,
  terminal-size,
  text,
  time,
  unix,
  vector,
  wcwidth,
  word8,
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "1.1.2.0";
  src = fetchzip {
    url = "https://github.com/maralorn/nix-output-monitor/archive/refs/tags/v1.1.2.0.tar.gz";
    sha256 = "03qhy4xzika41pxlmvpz3psgy54va72ipn9v1lv33l6369ikrhl1";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  executableHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  testHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    data-default
    directory
    extra
    filepath
    generic-optics
    HUnit
    lock-file
    MemoTrie
    mtl
    nix-derivation
    optics
    process
    random
    relude
    safe
    stm
    streamly
    terminal-size
    text
    time
    unix
    vector
    wcwidth
    word8
  ];
  homepage = "https://github.com/maralorn/nix-output-monitor";
  description = "Parses output of nix-build to show additional information";
  license = lib.licenses.agpl3Plus;
  maintainers = with lib.maintainers; [maralorn];
  passthru.updateScript = ./update.sh;
  testTarget = "unit-tests";
  buildTools = [installShellFiles];
  postInstall = ''
    cat > $out/bin/nom-build << EOF
    #!${runtimeShell}
    ${expect}/bin/unbuffer nix-build "\$@" 2>&1 | exec $out/bin/nom
    EOF
    chmod a+x $out/bin/nom-build
    installShellCompletion --zsh --name _nom-build ${builtins.toFile "completion.zsh" ''
      #compdef nom-build
      compdef nom-build=nix-build
    ''}
  '';
}
