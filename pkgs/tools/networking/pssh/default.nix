{ lib, fetchFromGitHub, python2Packages, openssh, rsync }:

python2Packages.buildPythonApplication rec {
  pname = "pssh";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "pssh";
    rev = "v${version}";
    sha256 = "0nawarxczfwajclnlsimhqkpzyqb1byvz9nsl54mi1bp80z5i4jq";
  };

  postPatch = ''
    for f in bin/*; do
      substituteInPlace $f \
        --replace "'ssh'" "'${openssh}/bin/ssh'" \
        --replace "'scp'" "'${openssh}/bin/scp'" \
        --replace "'rsync'" "'${rsync}/bin/rsync'"
    done
  '';

  meta = with lib; {
    description = "Parallel SSH Tools";
    longDescription = ''
      PSSH provides parallel versions of OpenSSH and related tools,
      including pssh, pscp, prsync, pnuke and pslurp.
    '';
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];
  };
}
