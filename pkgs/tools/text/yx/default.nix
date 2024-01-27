{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, libyaml
, testers
, installShellFiles
, yx
}:
stdenv.mkDerivation rec {
  pname = "yx";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "tomalok";
    repo = "yx";
    rev = version;
    sha256 = "sha256-SGbvmwm2xxRTULzmfloOnMqoSO3TghWDlMMFaEE5v7E=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libyaml ];

  patches = [
    # https://gitlab.com/tomalok/yx/-/merge_requests/8
    (fetchpatch {
      url = "https://gitlab.com/tomalok/yx/-/commit/6ed4358f6930f4f5e44480c0ec7d3d7ea085d372.diff";
      hash = "sha256-4OeYv1l+YkDTc1ZI+gH7I9wGlnXn5vGFqgpPwBz1HyI=";
    })
  ];

  doCheck = true;

  postInstall = ''
    installManPage $out/usr/share/man/man1/yx.1
    rm $out/usr/share/man/man1/yx.1
    find $out/usr -type d -empty -delete
  '';

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
