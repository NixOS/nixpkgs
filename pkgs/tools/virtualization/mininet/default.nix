{ stdenv, lib, fetchFromGitHub
, which
, python
, help2man
}:

let
  pyEnv = python.withPackages(ps: [ ps.setuptools ]);
in
stdenv.mkDerivation rec {
  pname = "mininet";
  version = "2.3.0d6";

  outputs = [ "out" "py" ];

  src = fetchFromGitHub {
    owner = "mininet";
    repo = "mininet";
    rev = version;
    sha256 = "0wc6gni9dxj9jjnw66a28jdvcfm8bxv1i776m5dh002bn5wjcl6x";
  };

  buildFlags = [ "mnexec" ];
  makeFlags = [ "PREFIX=$(out)" ];

  pythonPath = [ python.pkgs.setuptools ];
  buildInputs = [ python which help2man ];

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
      fullName = "Mininet 2.3.0d6 License";
    };
    platforms = platforms.linux;
    homepage = https://github.com/mininet/mininet;
    maintainers = with maintainers; [ teto ];
  };
}
