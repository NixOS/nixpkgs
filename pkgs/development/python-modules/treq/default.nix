{ stdenv, fetchurl, buildPythonPackage, service-identity, requests,
  six, mock, twisted, incremental, coreutils, gnumake, pep8, sphinx,
  openssl, pyopenssl }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "treq";
  version = "17.3.1";

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "313af6dedecfdde2750968dc17653b6147cf2340b3479d70031cf741f5be0cf6";
  };

  buildInputs = [
    pep8
    mock
  ];

  propagatedBuildInputs = [
    service-identity
    requests
    twisted
    incremental
    sphinx
    six
    openssl
    pyopenssl
  ];

  checkPhase = ''
    ${pep8}/bin/pep8 --ignore=E902 treq
    trial treq
  '';

  doCheck = false;
  # Failure: twisted.web._newclient.RequestTransmissionFailed: [<twisted.python.failure.Failure OpenSSL.SSL.Error: [('SSL routines', 'ssl3_get_server_certificate', 'certificate verify failed')]>]

  postBuild = ''
    ${coreutils}/bin/mkdir -pv treq
    ${coreutils}/bin/echo "${version}" | ${coreutils}/bin/tee treq/_version
    cd docs && ${gnumake}/bin/make html && cd ..
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/twisted/treq;
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
