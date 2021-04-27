{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
}:

buildGoModule rec {
  pname = "buf";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f1UcvsXWW+fMAgTRtHkEXmUN/DTrJ/Xd+9HbR2FjFog=";
  };

  patches = [
    ./skip_test_requiring_network.patch
  ];

  preCheck = ''
    export PATH=$PATH:$GOPATH/bin
  '';

  nativeBuildInputs = [ protobuf ];

  vendorSha256 = "sha256-XMGXVsSLEzuzujX5Fg3LLkgzyJY+nIBJEO9iI2t9eGc=";

  meta = with lib; {
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    homepage = "https://buf.build";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof ];
  };
}
