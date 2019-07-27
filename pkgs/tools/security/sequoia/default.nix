{ stdenv, fetchFromGitLab, lib
, git, nettle, llvmPackages_8, cargo, rustc
, rustPlatform, pkgconfig, glib
, openssl, sqlite, capnproto
, pythonSupport ? true, python37Packages ? null
}:

assert pythonSupport -> python37Packages != null;

rustPlatform.buildRustPackage rec {
  version = "0.9.0";
  pname = "sequoia";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    sha256 = "13dzwdzz33dy2lgnznsv8wqnw2501f2ggrkfwpqy5x6d1kgms8rj";
  };
  cargoSha256 = "1zcnkpzcar3a2fk2rn3i3nb70b59ds9fpfa44f15r3aaxajsdhdi";

  nativeBuildInputs = [
    pkgconfig
    cargo
    rustc
    git
    llvmPackages_8.libclang
    llvmPackages_8.clang
  ]
    ++ lib.optional pythonSupport python37Packages.cffi
    ++ lib.optional pythonSupport python37Packages.pytest
    ++ lib.optional pythonSupport python37Packages.pytestrunner
    ++ lib.optional pythonSupport python37Packages.setuptools
  ;
  buildInputs = [
    openssl
    sqlite
    nettle
    capnproto
  ]
    ++ lib.optional pythonSupport python37Packages.python
    ++ lib.optional pythonSupport python37Packages.cffi
  ;
  LIBCLANG_PATH = "${llvmPackages_8.libclang}/lib";

  # Set the Epoch to 1980; otherwise the Python wheel/zip code 
  # gets very angry SOURCE_DATE_EPOCH=315532800;
  preConfigure = ''
    find . -type f | while read file; do
      touch -d @315532800 $file
    done
  '';
  # Python bindings are enabled by default in the source distribution
  installPhase = if pythonSupport then ''
    make PREFIX=$out PYTHONPATH=$out/lib/python3.7/site-packages:$PYTHONPATH install
  '' else ''
    make PREFIX=$out PYTHON=disable install
  '';

  meta = with stdenv.lib; {
    description = "A Cool OpenPGP Library";
    homepage = "https://sequoia-pgp.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
