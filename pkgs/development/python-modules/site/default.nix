{ stdenv, python }:

stdenv.mkDerivation rec {
  name = "site-1.0";

  unpackPhase = "true";

  buildInputs = [ python ];

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      cat ${./site.py} >> $dst/site.py

      # by providing content for bin/ we make sure, that python or
      # some other script is linked instead of the bin/ directory
      # itself. This is needed for the wrappers to make all site
      # packages available if site is installed.
      mkdir $out/bin
      cat ${./pysite} >> $out/bin/pysite
      substituteInPlace $out/bin/pysite \
          --replace PYTHON_LIB_PREFIX ${python.libPrefix}
      chmod +x $out/bin/pysite
    '';

  meta = {
      description = "Enable processing of pth files anywhere in PYTHONPATH";
      longDescription = ''
        This file is normally created by easy_install / distutils in
        site-packages and overrides python's default site.py. It adds
        all parts of PYTHONPATH as site directories, which means pth
        files are processed in them. We remove the normally created
        site.py's and package it separately instead as it would cause
        collisions.

        For each module we have a pth file listing the module and all
        its dependencies and we include python-site into the
        PYTHONPATH of wrapped python programs so they can find their
        dependencies.
      '';
  };
}
