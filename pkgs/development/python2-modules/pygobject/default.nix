{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  python,
  buildPythonPackage,
  pkg-config,
  glib,
  isPy3k,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "2.28.7";
  format = "other";
  disabled = pythonAtLeast "3.9";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nkam61rsn7y3wik3vw46wk5q2cjfh2iph57hl9m39rc8jijb7dv";
  };

  outputs = [
    "out"
    "devdoc"
  ];

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./pygobject-2.0-fix-darwin.patch
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/f2975d5bbbc2459c661905c5a850cc661fa32f55/python/py-gobject/files/py-gobject-dynamic_lookup-11.patch";
      hash = "sha256-mtlyu+La3+iC5iQAmVJzDA5E35XGaRQy/EKXzvrWRCg=";
      extraPrefix = "";
    })
  ];

  configureFlags = [ "--disable-introspection" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ];

  # in a "normal" setup, pygobject and pygtk are installed into the
  # same site-packages: we need a pth file for both. pygtk.py would be
  # used to select a specific version, in our setup it should have no
  # effect, but we leave it in case somebody expects and calls it.
  postInstall = lib.optionalString (!isPy3k) ''
    mv $out/${python.sitePackages}/{pygtk.pth,${pname}-${version}.pth}

    # Prevent wrapping of codegen files as these are meant to be
    # executed by the python program
    chmod a-x $out/share/pygobject/*/codegen/*.py
  '';

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for GLib";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
