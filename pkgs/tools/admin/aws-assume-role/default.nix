{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "aws-assume-role";
  version = "0.3.2";

  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "remind101";
    repo = "assume-role";
    rev = "refs/tags/${version}";
    sha256 = "sha256-7+9qi9lYzv1YCFhUyla+5Gqs5nBUiiazhFwiqHzMFd4=";
  };

  vendorHash = null;

  postPatch = ''
    go mod init github.com/remind101/assume-role
  '';

  postInstall = ''
    install -Dm444 -t $out/share/doc/aws-assume-role README.md
  '';

  meta = with lib; {
    description = "Easily assume AWS roles in your terminal";
    homepage = "https://github.com/remind101/assume-role";
    license = licenses.bsd2;
    mainProgram = "assume-role";
    maintainers = with lib.maintainers; [ williamvds ];
    platforms = platforms.all;
  };
}
