{ buildGoModule
, fetchFromGitHub
, lib
, aclSupport ? true, acl
}:

buildGoModule rec {
  pname = "dtail";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mimecast";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dn8bcCgz3Bj7jsTS4O+RhhTh4qHXE3auRwgnomtrhvU=";
  };

  doCheck = false;

  buildInputs = lib.optional aclSupport acl;

  tags = lib.optional aclSupport "linuxacl";

  vendorSha256 = "sha256-egHNBnFwHIRmdr10GYyGNR9EfD8Xwiq4JZFOPJKF0NQ=";

  meta = with lib; {
    description = "A distribuited tool for tailing, and grepping logs";
    homepage = "https://github.com/mimecast/dtail";
    license = licenses.asl20;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.all;
  };
}
