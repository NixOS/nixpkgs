{ lib, stdenv, fetchurl, python3, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "mozlz4a";
  version = "2018-08-23";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://gist.githubusercontent.com/kaefer3000/73febe1eec898cd50ce4de1af79a332a/raw/a266410033455d6b4af515d7a9d34f5afd35beec/mozlz4a.py";
    sha256 = "1d1ai062kdms34bya9dlykkx011rj8d8nh5l7d76xj8k9kv4ssq6";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/${python3.sitePackages}/"
    cp "${src}" "$out/${python3.sitePackages}/mozlz4a.py"

    echo "#!${runtimeShell}" >> "$out/bin/mozlz4a"
    echo "export PYTHONPATH='$PYTHONPATH'" >> "$out/bin/mozlz4a"
    echo "'${python3}/bin/python' '$out/${python3.sitePackages}/mozlz4a.py' \"\$@\"" >> "$out/bin/mozlz4a"
    chmod a+x "$out/bin/mozlz4a"
  '';

  buildInputs = [ python3 python3.pkgs.lz4 ];

  meta = {
    description = "A script to handle Mozilla's mozlz4 files";
    license = lib.licenses.bsd2;
    maintainers = [lib.maintainers.raskin lib.maintainers.pshirshov lib.maintainers.kira-bruneau];
    platforms = lib.platforms.unix;
    homepage = "https://gist.githubusercontent.com/Tblue/62ff47bef7f894e92ed5";
  };
}
