{stdenv, fetchurl, python3, pylz4}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "mozlz4a";
  version = "2015-07-24";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://gist.githubusercontent.com/Tblue/62ff47bef7f894e92ed5/raw/2483756c55ed34be565aea269f05bd5eeb6b0a33/mozlz4a.py";
    sha256 = "1y52zqkdyfacl2hr5adkjphgqfyfylp8ksrkh165bq48zlbf00s8";
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

  buildInputs = [ pylz4 python3 ];

  meta = {
    inherit version;
    description = "A script to handle Mozilla's mozlz4 files";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://gist.githubusercontent.com/Tblue/62ff47bef7f894e92ed5";
  };
}
