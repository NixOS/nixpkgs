{ stdenv, fetchurl, buildPythonPackage, service-identity, requests2,
  six, mock, twisted, incremental, coreutils, gnumake, pep8, sphinx,
  openssl, pyopenssl }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "treq";
  version = "16.12.0";

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "1aci3f3rmb5mdf4s6s4k4kghmnyy784cxgi3pz99m5jp274fs25h";
  };

  buildInputs = [
    pep8
    mock
  ];

  propagatedBuildInputs = [
    service-identity
    requests2
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
