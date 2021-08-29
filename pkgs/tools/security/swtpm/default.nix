{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libtasn1, openssl, fuse, glib, libseccomp
, libtpms
, unixtools, expect, socat
, gnutls
, perl
, python3, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "swtpm";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${version}";
    sha256 = "sha256-KY5V4z/8I15ePjorgZueNahlD/xvFa3tDarA0tuRxFk=";
  };

  pythonPath = with python3Packages; requiredPythonModules [
    setuptools
    cryptography
  ];

  patches = [
    # upstream looks for /usr directory in $prefix to check
    # whether or not to proceed with installation of python
    # tools (swtpm_setup utility).
    ./python-installation.patch
  ];

  prePatch = ''
    patchShebangs src/swtpm_setup/setup.py
    patchShebangs samples/setup.py
  '';

  nativeBuildInputs = [
    pkg-config unixtools.netstat expect socat
    perl # for pod2man
    autoreconfHook
    python3
  ];
  buildInputs = [
    libtpms
    openssl libtasn1 libseccomp
    fuse glib
    gnutls
    python3.pkgs.wrapPython
  ];
  propagatedBuildInputs = pythonPath;

  configureFlags = [
    "--with-cuse"
  ];

  postInstall = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
    wrapPythonProgramsIn $out/share/swtpm "$out $pythonPath"
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
