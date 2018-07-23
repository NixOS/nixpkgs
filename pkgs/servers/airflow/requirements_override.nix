{ pkgs, python }:

let
  removeDependencies = names: deps:
    with builtins; with pkgs.lib;
      filter
      (drv: all
        (suf:
          ! hasSuffix ("-" + suf)
          (parseDrvName drv.name).name
        )
        names
      )
      deps;

in self: super: {

	"pyOpenSSL" = python.overrideDerivation super."pyOpenSSL" (old: {
    propagatedBuildInputs =
      removeDependencies [ "Sphinx" ] old.propagatedBuildInputs;
    doCheck = false;
  });

  "mock" = python.overrideDerivation super."mock" (old: {
    propagatedBuildInputs =
      removeDependencies [ "Sphinx" ] old.propagatedBuildInputs;
    doCheck = false;
  });

  "cryptography" = python.overrideDerivation super."cryptography" (old: {
    doCheck = false;
    propagatedBuildInputs =
      removeDependencies [ "Sphinx" ] old.propagatedBuildInputs;
  });

  "lxml" = python.overrideDerivation super."lxml" (old: {
    propagatedBuildInputs =
      removeDependencies [ "html5lib" ] old.propagatedBuildInputs;
  });

  "clickclick" = python.overrideDerivation super."clickclick" (old: {
    patchPhase = ''
      sed -i -e "s|setup_requires=\['six', 'flake8'\],||" setup.py
      sed -i -e "s|command_options=command_options,||" setup.py
    '';
  });

  "PyVCF" = python.overrideDerivation super."PyVCF" (old: {
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/20/b6/36bfb1760f6983788d916096193fc14c83cce512c7787c93380e09458c09/PyVCF-0.6.8.tar.gz";
      sha256 = "e9d872513d179d229ab61da47a33f42726e9613784d1cb2bac3f8e2642f6f9d9";
    };
    doCheck = false;
  });

  "lockfile" = python.overrideDerivation super."lockfile" (old: {
    buildInputs = super.lockfile.buildInputs ++ [self.pbr];
    doCheck = false;
  });

  "python-dateutil" = python.overrideDerivation super.python-dateutil (old: {
    buildInputs = super.lockfile.buildInputs ++ [pkgs.python27Packages.setuptools_scm];
  });

	"apache-airflow" = python.overrideDerivation super."apache-airflow" (old: {
    propagatedBuildInputs =
      removeDependencies [ "freezegun" ] old.propagatedBuildInputs;
    buildInputs = old.buildInputs ++ [pkgs.makeWrapper];
    postInstall = ''
      makeWrapper ${self.gunicorn}/bin/gunicorn $out/bin/gunicorn \
        --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH"
    '';
    doCheck = false;
  });

  "jira" = python.overrideDerivation super."jira" (old: {
    buildInputs = super.lockfile.buildInputs ++ [self.Sphinx pkgs.python27Packages.pytestrunner];
    doCheck = false;
  });

  "tenacity" = python.overrideDerivation super."tenacity" (old: {
    buildInputs = super.lockfile.buildInputs ++ [self.pbr];
    doCheck = false;
  });

  "pandas-gbq" = python.overrideDerivation super.pandas-gbq (old: {
    patchPhase = ''
      substituteInPlace setup.py \
        --replace "google-cloud-bigquery>=0.32.0" "google-cloud-bigquery"
    '';
    doCheck = false;
  });

  "apache-beam" = python.overrideDerivation super."apache-beam" (old: {
    buildInputs = super.lockfile.buildInputs ++ [self.nose];
    doCheck = false;
  });
}
