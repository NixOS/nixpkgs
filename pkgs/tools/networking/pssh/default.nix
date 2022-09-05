{ lib, fetchFromGitHub, python3Packages, openssh, rsync }:

python3Packages.buildPythonApplication rec {
  pname = "pssh";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "pssh";
    rev = "v${version}";
    hash = "sha256-B1dIa6hNeq4iE8GKVhTp3Gzq7vp+v5Yyzj8uF8X71yg=";
  };

  postPatch = ''
    for f in bin/*; do
      substituteInPlace $f \
        --replace "'ssh'" "'${openssh}/bin/ssh'" \
        --replace "'scp'" "'${openssh}/bin/scp'" \
        --replace "'rsync'" "'${rsync}/bin/rsync'"
    done
  '';

  # Tests do not run with python3: https://github.com/lilydjwg/pssh/issues/126
  doCheck = false;

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
