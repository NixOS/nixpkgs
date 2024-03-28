{ lib, python3Packages, fetchPypi, bash }:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p6+OF8MuAzcdTV4/CvZpjGaOrg7xcNuEddk7yC2sXIE=";
  };

  postPatch = ''
    # drop upper bound of idna requirement
    sed -ri "s/'(idna)<[^']+'/'\1'/" setup.py
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  checkPhase = ''
    runHook preCheck
    $out/bin/simp_le --test
    runHook postCheck
  '';

  # both setuptools-scm with pkg_resources and mock are runtime dependencies
  propagatedBuildInputs = with python3Packages; [ acme cryptography setuptools-scm josepy idna mock pyopenssl pytz six ];

  meta = with lib; {
    homepage = "https://github.com/zenhack/simp_le";
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner makefu ];
    platforms = platforms.linux;
  };
}
