
{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-X52sf21IMr5muEx9SUoYQmFonXDPeW8NKylPmoAZYjw";
  };

  vendorHash = "sha256-lO4H2DlMfYuV2BYPnMV3Ynx0khFE6KDxf/aXA53pBpU";

  patches = [
    (fetchpatch {
      name = "CVE-2023-29193.patch";
      url = "https://github.com/authzed/spicedb/commit/9bbd7d76b6eaba33fe0236014f9b175d21232999.patch";
      sha256 = "sha256-4tldtTg5LUDmTPxIgZYEX7JMCx6Dxu99UaEnQwWTrnw=";
    })
  ];

  subPackages = [ "cmd/spicedb" ];

  meta = with lib; {
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
