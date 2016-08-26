{ stdenv,
  buildPythonApplication,
  fetchurl,
  twisted,
  dateutil,
  jinja2,
  sqlalchemy,
  sqlalchemy_migrate,
  pysqlite2,
}:

buildPythonApplication (rec {
  name = "buildbot-0.8.14";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/39/19/c8f8845d302b7df9d44a86a00911ccd12c0f8835bd6c562ae57b826fda29/buildbot-0.8.14.tar.gz";
    sha256 = "0r79fs305qdr2rjfg3kpip4350ypx00qh9gvm0ic48kmpl3zs7ik";
  };

  propagatedBuildInputs =
    [ twisted
      dateutil
      jinja2
      sqlalchemy
      sqlalchemy_migrate
      pysqlite2
    ];

  doCheck = false;
  # error: invalid command 'trial' 

  postInstall = ''
    mkdir -p "$out/share/man/man1"
    cp docs/buildbot.1 "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Continuous integration system that automates the build/test cycle";
    longDescription =
      '' The BuildBot is a system to automate the compile/test cycle
         required by most software projects to validate code changes.
      '';
    maintainers = with maintainers; [ bjornfor nand0p ];
    platforms = platforms.all;
  };
})
