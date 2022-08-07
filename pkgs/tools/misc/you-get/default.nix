{ lib
, python3
, substituteAll
, ffmpeg
, installShellFiles
}:

python3.pkgs.buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1620";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-wCDaT9Nz1ZiSsqFwX1PXHq6QF6fjLRI9wwvvWxcmYOY=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = "${lib.getBin ffmpeg}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg}/bin/ffmpeg";
      version = lib.getVersion ffmpeg;
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd you-get \
      --zsh contrib/completion/_you-get \
      --fish contrib/completion/you-get.fish \
      --bash contrib/completion/you-get-completion.bash
  '';

  meta = with lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    changelog = "https://github.com/soimort/you-get/raw/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
