{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "boulder";
  version = "2022-06-21";
  rev = "09f87bb31a57f9a04932b7175fab1e3cabffd86f";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    rev = "release-${version}";
    sha256 = "sha256-Q5fMM3UXMFqmpJks1xnINeKBA7dDam4bfczO3D43Yoo=";
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
    broken = stdenv.isDarwin;
  };
}
