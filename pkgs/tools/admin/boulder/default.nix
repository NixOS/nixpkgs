{ lib
, fetchFromGitHub
, buildGoModule
, gitUpdater
}:

buildGoModule rec {
  pname = "boulder";
  version = "2022-07-11";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    rev = "release-${version}";
    sha256 = "sha256-fDKB7q2e+qdHt+t/BQWX7LkpyiZQtZSHp/x5uv0/c7c=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorSha256 = null;

  subPackages = [ "cmd/boulder" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/letsencrypt/boulder/core.BuildHost=nixbld@localhost"
  ];

  preBuild = ''
    ldflags+=" -X \"github.com/letsencrypt/boulder/core.BuildID=$(cat COMMIT)\""
    ldflags+=" -X \"github.com/letsencrypt/boulder/core.BuildTime=$(date -u -d @0)\""
  '';

  postInstall = ''
    for i in $($out/bin/boulder --list); do
      ln -s $out/bin/boulder $out/bin/$i
    done
  '';

  # There are no tests for cmd/boulder.
  doCheck = false;

  passthru.updateScript = gitUpdater {
    inherit pname version;
    rev-prefix = "release-";
  };

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
