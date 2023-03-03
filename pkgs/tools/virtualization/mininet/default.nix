{ stdenv, lib, fetchFromGitHub
, which
, python3
, help2man
}:

let
  pyEnv = python3.withPackages(ps: [ ps.setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "mininet";
  version = "2.3.0";

  outputs = [ "out" "py" ];

  src = fetchFromGitHub {
    owner = "mininet";
    repo = "mininet";
    rev = version;
    sha256 = "sha256-bCppmeB+zQMKTptnzhsXtl72XJXU3USo7cQgP1Z6SrY=";
  };

  buildFlags = [ "mnexec" ];
  makeFlags = [ "PREFIX=$(out)" ];

  pythonPath = [ python3.pkgs.setuptools ];
  nativeBuildInputs = [ help2man ];

  propagatedBuildInputs = [ python3 which ];

  installTargets = [ "install-mnexec" "install-manpages" ];

  preInstall = ''
    mkdir -p $out $py
    # without --root, install fails
    ${pyEnv.interpreter} setup.py install --root="/" --prefix=$py
  '';

  doCheck = false;


  meta = with lib; {
    description = "Emulator for rapid prototyping of Software Defined Networks";
    license = {
      fullName = "Mininet 2.3.0 License";
    };
    platforms = platforms.linux;
    homepage = "https://github.com/mininet/mininet";
    maintainers = with maintainers; [ teto ];
  };
}
