{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "pssh-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "pssh";
    rev = "v${version}";
    sha256 = "0nawarxczfwajclnlsimhqkpzyqb1byvz9nsl54mi1bp80z5i4jq";
  };

  meta = with stdenv.lib; {
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
