{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "dyff";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "dyff";
    rev = "v${version}";
    sha256 = "0r1nfwglyw8b46n17bpmgscfmjhjsbk83lgkpm63ysy0h5r84dq8";
  };

  vendorSha256 = "12mirnw229x5jkzda0c45vnjnv7fjvzf0rm3fcy5f3wza6hkx6q7";

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
