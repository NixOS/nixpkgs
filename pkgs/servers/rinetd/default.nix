{ lib
, autoreconfHook
, fetchFromGitHub
, rinetd
, stdenv
, testers
}:

stdenv.mkDerivation rec {
  pname = "rinetd";
  version = "0.73";

  src = fetchFromGitHub {
    owner = "samhocevar";
    repo = "rinetd";
    rev = "v${version}";
    hash = "sha256-W8PLGd3RwmBTh1kw3k8+ZfP6AzRhZORCkxZzQ9ZbPN4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  preConfigure = ''
    ./bootstrap
  '';

  passthru.tests.version = testers.testVersion {
    package = rinetd;
    command = "rinetd --version";
  };

  meta = with lib; {
    description = "TCP/UDP port redirector";
    homepage = "https://github.com/samhocevar/rinetd";
    changelog = "https://github.com/samhocevar/rinetd/blob/${src.rev}/CHANGES.md";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "rinetd";
  };
}
