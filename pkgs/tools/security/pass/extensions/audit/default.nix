{ lib, stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper, gnupg }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [ p.requests p.setuptools p.zxcvbn ]);

in stdenv.mkDerivation rec {
  pname = "pass-audit";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-audit";
    rev = "v${version}";
    sha256 = "sha256-xigP8LxRXITLF3X21zhWx6ooFNSTKGv46yFSt1dd4vs=";
  };

  patches = [
    ./0001-Set-base-to-an-empty-value.patch
    ./0002-Fix-audit.bash-setup.patch
  ];

  postPatch = ''
    substituteInPlace audit.bash \
      --replace 'python3' "${pythonEnv}/bin/python3"
    substituteInPlace Makefile \
      --replace "install --root" "install --prefix ''' --root"
  '';

  outputs = [ "out" "man" ];

  buildInputs = [ pythonEnv ];
  nativeBuildInputs = [ makeWrapper ];

  # Tests freeze on darwin with: pass-audit-1.1 (checkPhase): EOFError
  doCheck = !stdenv.isDarwin;
  nativeCheckInputs = [ pythonPackages.green pass gnupg ];
  checkPhase = ''
    ${pythonEnv}/bin/python3 setup.py green -q
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];
  postInstall = ''
    wrapProgram $out/lib/password-store/extensions/audit.bash \
      --prefix PYTHONPATH : "$out/lib/${pythonEnv.libPrefix}/site-packages" \
      --run "export COMMAND"
  '';

  meta = with lib; {
    description = "Pass extension for auditing your password repository.";
    homepage = "https://github.com/roddhjav/pass-audit";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma27 ];
  };
}
