{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sshed";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trntv";
    repo = "sshed";
    rev = version;
    sha256 =  "sha256-y8IQzOGs78T44jLcNNjPlfopyptX3Mhv2LdawqS1T+U=";
  };

  vendorHash = "sha256-21Vh5Zaja5rx9RVCTFQquNvMNvaUlUV6kfhkIvXwbVw=";

  preInstall = ''
    mv "$GOPATH/bin/cmd" "$GOPATH/bin/sshed"
  '';

  meta = with lib; {
    description = "ssh config editor and bookmarks manager";
    homepage = "https://github.com/trntv/sshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ _2gn ];
    platforms = platforms.unix;
  };
}
