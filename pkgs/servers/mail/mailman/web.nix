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

  postPatch = ''
    # This is just so people installing from pip also get uwsgi
    # installed, AFAICT.
    sed -i '/^  uwsgi$/d' setup.cfg

    # Django is depended on transitively by hyperkitty and postorius,
    # and mailman_web has overly restrictive version bounds on it, so
    # let's remove it.
    sed -i '/^  Django/d' setup.cfg

    # Upstream seems to mostly target installing on top of existing
    # distributions, and uses a path appropriate for that, but we are
    # a distribution, so use a state directory appropriate for a
    # distro package.
    substituteInPlace mailman_web/settings/base.py \
        --replace /opt/mailman/web /var/lib/mailman-web
  '';

  nativeBuildInputs = [ git makeWrapper setuptools-scm ];
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
