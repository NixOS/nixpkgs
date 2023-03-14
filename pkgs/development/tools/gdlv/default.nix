{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, OpenGL
, AppKit
}:

buildGoModule rec {
  pname = "gdlv";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${version}";
    sha256 = "sha256-G1/Wbz836yfGZ/1ArICrNbWU6eh4SHXDmo4FKkjUszY=";
  };

  vendorSha256 = null;
  subPackages = ".";

  buildInputs = lib.optionals stdenv.isDarwin [ OpenGL AppKit ];

  meta = with lib; {
    description = "GUI frontend for Delve";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.gpl3;
  };
}
