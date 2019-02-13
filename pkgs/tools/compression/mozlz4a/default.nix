{ stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "mozlz4a";
  version = "2018-08-23";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://gist.githubusercontent.com/kaefer3000/73febe1eec898cd50ce4de1af79a332a/raw/a266410033455d6b4af515d7a9d34f5afd35beec/mozlz4a.py";
    sha256 = "1d1ai062kdms34bya9dlykkx011rj8d8nh5l7d76xj8k9kv4ssq6";
  };

  unpackPhase = "true;";

  installPhase = ''
    mkdir -p "$out/bin" "$out/${python3.sitePackages}/"
    cp "${src}" "$out/${python3.sitePackages}/mozlz4a.py"

    echo "#!${stdenv.shell}" >> "$out/bin/mozlz4a"
    echo "export PYTHONPATH='$PYTHONPATH'" >> "$out/bin/mozlz4a"
    echo "'${python3}/bin/python' '$out/${python3.sitePackages}/mozlz4a.py' \"\$@\"" >> "$out/bin/mozlz4a"
    chmod a+x "$out/bin/mozlz4a"
  '';

  buildInputs = [ python3 python3.pkgs.python-lz4 ];

  meta = {
    inherit version;
    description = "A script to handle Mozilla's mozlz4 files";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://gist.githubusercontent.com/Tblue/62ff47bef7f894e92ed5;
  };
}
