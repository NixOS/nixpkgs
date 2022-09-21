{ lib
, python3Packages
, fetchFromGitHub
, tpm2-tools
, python3
, pkg-config
, swig
, efivar
, libssl
}:

python3Packages.buildPythonApplication rec {
  pname = "keylime";
  version = "7.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "keylime";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1lzLlyoNtIg21ximAr9f0Nj5MOIgXbnqLlAe3BUUKs8=";
  };

  buildInputs = [ efivar libssl ];

  propagatedBuildInputs = [
    tpm2-tools
  ] ++ (with python3.pkgs; [
    cryptography
    tornado
    pyzmq
    pyyaml
    requests
    sqlalchemy
    alembic
    packaging
    psutil
    lark
    pyasn1
    pyasn1-modules
    jinja2
    gpgme
    jsonschema
    typing-extensions
  ]);

  postInstall = ''
    install -D keylime.conf $out/etc/keylime.conf
    install -D config/verifier.conf $out/etc/config/verifier.conf
    install -D config/tenant.conf $out/etc/config/tenant.conf
    install -D config/registrar.conf $out/etc/config/registrar.conf
    install -D config/ca.conf $out/etc/config/ca.conf
    install -D config/logging.conf $out/etc/config/logging.conf

    # for enabling tests
    substituteInPlace $out/lib/${python3.libPrefix}/site-packages/keylime/config.py --replace "libefivar.so.1" "${efivar.out}/lib/libefivar.so.1"
  '';

  # TODO: Enable tests
  doCheck = false;

  # TODO: tests are still broken
  preCheck = ''
    export KEYLIME_CONFIG=$out/etc/keylime.conf
  '';

  checkInputs = [
    tpm2-tools
    efivar
  ];

  meta = with lib; {
    description = "A CNCF Project to Bootstrap & Maintain Trust on the Edge/Cloud and IoT";
    homepage = "https://keylime.dev";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkivm ];
  };
}
