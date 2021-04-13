{ buildPythonPackage, lib, fetchgit, isPy3k
, git, makeWrapper, sassc, hyperkitty, postorius, whoosh, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mailman-web";
  version = "unstable-2021-04-10";
  disabled = !isPy3k;

  src = fetchgit {
    url = "https://gitlab.com/mailman/mailman-web";
    rev = "19a7abe27dd3bc39c0250440de073f0adecd4da1";
    sha256 = "0h25140n2jaisl0ri5x7gdmbypiys8vlq8dql1zmaxvq459ybxkn";
    leaveDotGit = true;
  };

  # This is just so people installing from pip also get uwsgi
  # installed, AFAICT.

  # Django is depended on transitively by hyperkitty and postorius,
  # and mailman_web has overly restrictive version bounds on it, so
  # let's remove it.
  postPatch = ''
    sed -i '/^  uwsgi$/d' setup.cfg
    sed -i '/^  Django/d' setup.cfg
  '';

  nativeBuildInputs = [ git setuptools-scm makeWrapper ];
  propagatedBuildInputs = [ hyperkitty postorius whoosh ];

  # Tries to check runtime configuration.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/mailman-web \
        --suffix PATH : ${lib.makeBinPath [ sassc ]}
  '';

  meta = with lib; {
    description = "Django project for Mailman 3 web interface";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peti qyliss m1cr0man ];
  };
}
