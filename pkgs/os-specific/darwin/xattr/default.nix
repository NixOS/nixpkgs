{ lib
, stdenv
, fetchzip
, buildPythonPackage
, python
, ed
, unifdef
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "61.60.1";

  src = fetchzip rec {
    url = "https://opensource.apple.com/tarballs/python_modules/python_modules-${version}.tar.gz";
    sha256 = "19kydl7w4vpdi7zmfd5z9vjkq24jfk2cv4j0pppw69j06czhdwwi";
  };

  sourceRoot = "${src.name}/Modules/xattr-0.6.4";
  format = "other";

  nativeBuildInputs = [
    ed
    unifdef
  ];

  makeFlags = [
    "OBJROOT=$(PWD)"
    "DSTROOT=${placeholder "out"}"
    "OSL=${placeholder "doc"}/share/xattr/OpenSourceLicenses"
    "OSV=${placeholder "doc"}/share/xattr/OpenSourceVersions"
  ];

  # need to use `out` instead of `bin` since buildPythonPackage ignores the latter
  outputs = [ "out" "doc" "python" ];

  # We need to patch a reference to gnutar in an included Makefile
  postUnpack = ''
    chmod u+w $sourceRoot/..
  '';

  postPatch = ''
    substituteInPlace ../Makefile.inc --replace gnutar tar
    substituteInPlace Makefile --replace "/usr" ""
  '';

  preInstall = ''
    # prevent setup.py from trying to download setuptools
    sed -i xattr-*/setup.py -e '/ez_setup/d'

    # create our custom target dirs we patch in
    mkdir -p "$doc/share/xattr/"OpenSource{Licenses,Versions}
    mkdir -p "$python/lib/${python.libPrefix}"
  '';

  # move python package to its own output to reduce clutter
  postInstall = ''
    mv "$out/lib/python" "$python/${python.sitePackages}"
    rmdir "$out/lib"
  '';

  makeWrapperArgs = [
    "--prefix" "PYTHONPATH" ":" "${placeholder "python"}/${python.sitePackages}"
  ];

  meta = with lib; {
    description = "Display and manipulate extended attributes";
    license = [ licenses.psfl licenses.mit ]; # see $doc/share/xattr/OpenSourceLicenses
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://opensource.apple.com/source/python_modules/";
    platforms = lib.platforms.darwin;
  };
}
