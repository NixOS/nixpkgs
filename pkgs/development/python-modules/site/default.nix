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
