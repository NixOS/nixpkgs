{ lib, python3Packages, fetchFromGitHub, sg3_utils }:

python3Packages.buildPythonApplication rec {
  pname = "sasutils";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "stanford-rc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kh5pcc2shdmrvqqi2y1zamzsfvk56pqgwqgqhjfz4r6yfpm04wl";
  };

  propagatedBuildInputs = [ sg3_utils ];

  meta = with lib; {
    homepage = "https://github.com/stanford-rc/sasutils";
    description = "A set of command-line tools to ease the administration of Serial Attached SCSI (SAS) fabrics";
    license = licenses.asl20;
    maintainers = with maintainers; [ aij ];
  };
}
