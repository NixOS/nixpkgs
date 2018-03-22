{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages, bash }:
 
pythonPackages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.8.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0nv9mm99rm8i9flgfgwvmajbsxb5rm162nfxlq3wk66bbbyr6y1i";
  };

  postPatch = ''
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with pythonPackages; [ acme setuptools_scm josepy ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zenhack/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner makefu ];
    platforms = platforms.all;
  };
}

