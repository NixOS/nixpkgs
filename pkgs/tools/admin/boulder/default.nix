{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "boulder";
  version = "release-2022-05-31";
  rev = "99dcb9a5b31be576a55e33184581c942421bc172";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    rev = version;
    sha256 = "sha256-x1Vf8agwVTgSkDVEdAnG3div+MzRsMi96jKJRc2s8Ks=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/boulder" ];

  ldflags = with lib;
    mapAttrsToList (n: v: ''"-X github.com/letsencrypt/boulder/core.Build${n}=${v}"'') {
      ID = substring 0 8 rev;
      Host = "nixbld@localhost";
      Time = "Thu  1 Jan 00:00:00 UTC 1970";
    };

  postInstall = ''
    for i in $($out/bin/boulder --list); do
      ln -s $out/bin/boulder $out/bin/$i
    done
  '';

  # There are no tests for cmd/boulder.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/letsencrypt/boulder";
    description = "An ACME-based certificate authority, written in Go";
    longDescription = ''
      This is an implementation of an ACME-based CA. The ACME protocol allows
      the CA to automatically verify that an applicant for a certificate
      actually controls an identifier, and allows domain holders to issue and
      revoke certificates for their domains. Boulder is the software that runs
      Let's Encrypt.
    '';
    license = licenses.mpl20;
    maintainers = with maintainers; [ azahi ];
  };
}
