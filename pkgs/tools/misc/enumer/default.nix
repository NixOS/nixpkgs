{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "enumer";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    rev = "refs/tags/v${version}";
    hash = "sha256-2fVWrrWOiCtg7I3Lul2PgQ2u/qDEDioPSB61Tp0rfEo=";
  };

  vendorSha256 = "sha256-BmFv0ytRnjaB7z7Gb+38Fw2ObagnaFMnMhlejhaGxsk=";

  meta = with lib; {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
