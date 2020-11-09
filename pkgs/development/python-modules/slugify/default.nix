{ stdenv, fetchPypi, buildPythonPackage, python, text-unidecode }:

buildPythonPackage rec {
    pname = "slugify";
    version = "0.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0k2y4cc0zkh3lzsifdx5hidbpf36cwqbps1wdx9lfs8s3k0kqw65";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/zacharyvoase/slugify";
      description = "A generic slugifier utility, inspired by Django’s slugify template filter.";
      license = licenses.unlicense;
      platforms = platforms.all;
      maintainers = with maintainers; [  ];
    };
}
