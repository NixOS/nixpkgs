{ lib, nimPackages, fetchFromGitHub, nim }:

nimPackages.buildNimPackage rec {
  pname = "osh-tool";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hoijui";
    repo = pname;
    rev = "55c736b346d438dab6e3ab652ec15ee7e10847aa";
    hash = "sha256-BDuMWpu/l+q0wJEv36LXXDOI2b0Fu6OHrf5ebV4cFt0=";
    fetchSubmodules = true;
  };

  buildInputs = with nimPackages; [ unicodedb docopt regex result shell ];

  nimBinOnly = true;

  preBuild = ''
    mv src/main.nim src/osh.nim
    substituteInPlace osh_tool.nimble \
      --replace 'binDir = "build"' 'srcDir = "src"' \
      --replace 'namedBin["src/main"] = "osh"' 'bin = @["osh"]'
  '';

  meta = with lib; {
    description =
      "A Tool for managing Open Source Hardware projects, taking care of meta-data and keeping the structure clean";
    homepage = "https://github.com/hoijui/osh-tool";
    license = lib.licenses.agpl3;
    mainProgram = "osh";
    maintainers = with maintainers; [ sourceindex ];
  };
}
