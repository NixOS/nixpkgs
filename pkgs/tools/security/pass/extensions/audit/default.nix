{ stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper, gnupg }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [ p.requests p.setuptools p.zxcvbn ]);

in stdenv.mkDerivation rec {
  pname = "pass-audit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-audit";
    rev = "v${version}";
    sha256 = "1mdckw0dwcnv8smp1za96y0zmdnykbkw2606v7mzfnzbz4zjdlwl";
  };

  patches = [
    ./0001-Make-it-possible-to-run-the-tests-offline.patch
    ./0002-Fix-audit.bash-setup.patch
  ];

  postPatch = ''
    substituteInPlace audit.bash \
      --replace '/usr/bin/env python3' "${pythonEnv}/bin/python3"
  '';

  outputs = [ "out" "man" ];

  buildInputs = [ pythonEnv ];
  nativeBuildInputs = [ makeWrapper ];

  doCheck = true;
  checkInputs = [ pythonPackages.green pass gnupg ];
  checkPhase = ''
    ${pythonEnv}/bin/python3 setup.py green -q
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];
  postInstall = ''
    wrapProgram $out/lib/password-store/extensions/audit.bash \
      --prefix PYTHONPATH : "$out/lib/${pythonEnv.libPrefix}/site-packages"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension for auditing your password repository.";
    homepage = https://github.com/roddhjav/pass-audit;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma27 ];
  };
}
