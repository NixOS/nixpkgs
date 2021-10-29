{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "dyff";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "dyff";
    rev = "v${version}";
    sha256 = "sha256-TaGtl5TBQMHjY4/HmDUghyhrsc5fjSMmY+oqO+rKGo4=";
  };

  vendorSha256 = "sha256-3L3FtL/P+Jyvv0WESBvfSxJOl99v5QDyyzIqottB2EI=";

  subPackages = [
    "cmd/dyff"
    "pkg/dyff"
    "internal/cmd"
  ];

  meta = with lib; {
    description = "A diff tool for YAML files, and sometimes JSON";
    longDescription = ''
      dyff is inspired by the way the old BOSH v1 deployment output reported
      changes from one version to another by only showing the parts of a YAML
      file that change.

      Each difference is referenced by its location in the YAML document by
      using either the Spruce or go-patch path syntax.
    '';
    homepage = "https://github.com/homeport/dyff";
    license = licenses.mit;
    maintainers = with maintainers; [ edlimerkaj ];
  };
}
