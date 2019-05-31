{ stdenv, python3Packages, bash }:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.14.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0kqdgbdb835b74l8y79n2nvwgvbz07ij5k7f3q3hj7w4y49ribr3";
  };

  postPatch = ''
    # drop upper bound of acme requirement
    sed -ri "s/'(acme>=[^,]+),<[^']+'/'\1'/" setup.py
    # drop upper bound of idna requirement
    sed -ri "s/'(idna)<[^']+'/'\1'/" setup.py
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with python3Packages; [ acme setuptools_scm josepy idna ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zenhack/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner makefu ];
    platforms = platforms.linux;
  };
}
