{ lib, python3Packages, fetchPypi, bash }:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m1jynar4calaffp2zdxr5yy9vnhw2qf2hsfxwzfwf8fqb5h7bjb";
  };

  postPatch = ''
    # drop upper bound of idna requirement
    sed -ri "s/'(idna)<[^']+'/'\1'/" setup.py
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with python3Packages; [ acme setuptools-scm josepy idna ];

  nativeCheckInputs = with python3Packages; [ mock ];

  meta = with lib; {
    homepage = "https://github.com/zenhack/simp_le";
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner makefu ];
    platforms = platforms.linux;
  };
}
