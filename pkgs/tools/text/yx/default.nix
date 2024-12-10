{
  lib,
  stdenv,
  fetchFromGitLab,
  libyaml,
  testers,
  yx,
}:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = "yx";
    rev = version;
    hash = "sha256-uuso+hsmdsB7VpIRKob8rfMaWvRMCBHvCFnYrHPC6iw=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  buildInputs = [ libyaml ];

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = yx;
    command = "${meta.mainProgram} -v";
    version = "v${yx.version}";
  };

  meta = with lib; {
    description = "YAML Data Extraction Tool";
    homepage = "https://gitlab.com/tomalok/yx";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ twz123 ];
    mainProgram = "yx";
  };
}
