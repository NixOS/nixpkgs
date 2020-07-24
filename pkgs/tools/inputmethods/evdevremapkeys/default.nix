{ stdenv, fetchFromGitHub, python3Packages }:

let
  pythonPackages = python3Packages;

in pythonPackages.buildPythonPackage rec {
  name = "${pname}-0.1.0";
  pname = "evdevremapkeys";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = pname;
    rev = "68fb618b8142e1b45d7a1e19ea9a5a9bbb206144";
    sha256 = "0c9slflakm5jqd8s1zpxm7gmrrk0335m040d7m70hnsak42jvs2f";
  };

  propagatedBuildInputs = with pythonPackages; [ 
    pyyaml
    pyxdg
    python-daemon
    evdev
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/philipl/evdevremapkeys";
    description = "Daemon to remap events on linux input devices";
    license = licenses.mit;
    maintainers = [ maintainers.q3k ];
    platforms = platforms.linux;
  };
}
