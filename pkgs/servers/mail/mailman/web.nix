{ buildPythonPackage, lib, fetchgit, isPy3k
, git, makeWrapper, sassc, hyperkitty, postorius, whoosh
}:

buildPythonPackage rec {
  pname = "mailman-web-unstable";
  version = "2019-09-29";
  disabled = !isPy3k;

  src = fetchgit {
    url = "https://gitlab.com/mailman/mailman-web";
    rev = "d17203b4d6bdc71c2b40891757f57a32f3de53d5";
    sha256 = "124cxr4vfi1ibgxygk4l74q4fysx0a6pga1kk9p5wq2yvzwg9z3n";
    leaveDotGit = true;
  };

  # This is just so people installing from pip also get uwsgi
  # installed, AFAICT.
  postPatch = ''
    sed -i '/^  uwsgi$/d' setup.cfg
  '';

  nativeBuildInputs = [ git makeWrapper ];
  propagatedBuildInputs = [ hyperkitty postorius whoosh ];

  # Tries to check runtime configuration.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/mailman-web \
        --suffix PATH : ${lib.makeBinPath [ sassc ]}
  '';

  meta = with lib; {
    description = "Django project for Mailman 3 web interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ qyliss ];
  };
}
