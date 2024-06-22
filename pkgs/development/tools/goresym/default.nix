{ lib
, fetchFromGitHub
, buildGoModule
, unzip
}:

buildGoModule rec {
  pname = "goresym";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qFDacInIiV1thuYMjyzTG7ru5bkd2Af1iao7Oes1mRg=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-pjkBrHhIqLmSzwi1dKS5+aJrrAAIzNATOt3LgLsMtx0=";

  nativeCheckInputs = [ unzip ];

  preCheck = ''
    cd test
    unzip weirdbins.zip
    cd ..
  '';

  doCheck = true;

  meta = with lib; {
    description = "Go symbol recovery tool";
    mainProgram = "GoReSym";
    homepage = "https://github.com/mandiant/GoReSym";
    changelog = "https://github.com/mandiant/GoReSym/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pyrox0 ];
  };
}
