{ mkDerivation, ansi-terminal, async, attoparsec, base, containers
, cassava, directory, HUnit, mtl, nix-derivation, process, relude, lib
, stm, terminal-size, text, time, unix, wcwidth, fetchFromGitHub
, lock-file, data-default, expect, runtimeShell
}:
mkDerivation rec {
  pname = "nix-output-monitor";
  version = "1.0.3.1";
  src = fetchFromGitHub {
    owner = "maralorn";
    repo = "nix-output-monitor";
    sha256 = "1kkf6cqq8aba8vmfcww30ah9j44bwakanyfdb6595vmaq5hrsq92";
    rev = "v${version}";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal async attoparsec base cassava containers directory mtl
    nix-derivation relude stm terminal-size text time unix wcwidth lock-file
    data-default
  ];
  executableHaskellDepends = [
    ansi-terminal async attoparsec base containers directory mtl
    nix-derivation relude stm text time unix
  ];
  testHaskellDepends = [
    ansi-terminal async attoparsec base containers directory HUnit mtl
    nix-derivation process relude stm text time unix
  ];
  postInstall = ''
    cat > $out/bin/nom-build << EOF
    #!${runtimeShell}
    ${expect}/bin/unbuffer nix-build "\$@" 2>&1 | exec $out/bin/nom
    EOF
    chmod a+x $out/bin/nom-build
  '';
  homepage = "https://github.com/maralorn/nix-output-monitor";
  description = "Parses output of nix-build to show additional information";
  license = lib.licenses.agpl3Plus;
  maintainers = [ lib.maintainers.maralorn ];
}
