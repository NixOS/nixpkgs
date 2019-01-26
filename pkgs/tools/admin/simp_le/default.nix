{ stdenv, python3Packages, bash }:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.9.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1yxfznd78zkg2f657v520zj5w4dvq5n594d0kpm4lra8xnpg4zcv";
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
