{ stdenv, lib, fetchFromGitHub
, which
, python
, help2man
}:

let
  pyEnv = python.withPackages(ps: [ ps.setuptools ]);
in
stdenv.mkDerivation rec {
  name = "mininet-${version}";
  version = "2.3.0d4";

  outputs = [ "out" "py" ];

  src = fetchFromGitHub {
    owner = "mininet";
    repo = "mininet";
    rev = version;
    sha256 = "02hsqa7r5ykj8m1ycl32xwn1agjrw78wkq87xif0dl2vkzln41i4";
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
      fullName = "Mininet 2.3.0d4 License";
    };
    homepage = https://github.com/mininet/mininet;
    maintainers = with maintainers; [ teto ];
  };
}
