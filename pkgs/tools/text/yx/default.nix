{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, libyaml
, testers
, runCommand
, yx
}:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = "yx";
    rev = version;
    sha256 = "sha256-oY61V9xP0DwRooabzi0XtaFsQa2GwYbuvxfERXQtYcA=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  buildInputs = [ libyaml ];

  patches = [
    # https://gitlab.com/tomalok/yx/-/issues/1
    (fetchpatch {
      url = "https://gitlab.com/tomalok/yx/-/commit/ef93d581552cf69d9396773fc8ceb849e588980c.diff";
      hash = "sha256-Au4s/AKKKiCB9JMl27boRth69KlPsSp/Gd7qwGfRYo4=";
    })
  ];

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = yx;
    command = "${meta.mainProgram} -v";
    version = "v${yx.version}";
  };

  passthru.tests.isssue-1-glibc-oob-read = runCommand "${pname}-isssue-1-test" { } ''
    for i in $(seq 1 100); do
      actual=$(printf 'a:\n- b:' | ${yx}/bin/${meta.mainProgram} a 1)
      if [ "$actual" != b ]; then
        echo Affected by https://gitlab.com/tomalok/yx/-/issues/1
        exit 1
      fi
    done
    touch $out
  '';

  meta = with lib; {
    description = "YAML Data Extraction Tool";
    homepage = "https://gitlab.com/tomalok/yx";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ twz123 ];
    mainProgram = "yx";
  };
}
