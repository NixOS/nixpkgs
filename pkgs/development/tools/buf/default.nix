{ lib
, buildGoModule
, fetchFromGitHub
, protobuf
}:

buildGoModule rec {
  pname = "buf";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N6o+1cfer8rgKJ3+CL25axJSjGV/YSG1sLIHXJzsC6o=";
  };

  patches = [
    ./skip_test_requiring_network.patch
  ];

  preCheck = ''
    export PATH=$PATH:$GOPATH/bin
  '';

  nativeBuildInputs = [ protobuf ];

  vendorSha256 = "sha256-vl+WqtpegoAvylx/lcyfJk8DAOub8U4Lx3Pe3eW4M/E=";

  meta = with lib; {
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    homepage = "https://buf.build";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof ];
  };
}
