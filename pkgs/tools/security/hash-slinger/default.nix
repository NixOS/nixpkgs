{ lib
, stdenv
, fetchFromGitHub
, python3
, unbound
, libreswan
}:

stdenv.mkDerivation rec {
  pname = "hash-slinger";
<<<<<<< HEAD
  version = "3.3";
=======
  version = "3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "letoams";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-c6IZHUFuhcccUWZYSOUGFbKpTtwMclIvEvDX8gE5d8o=";
=======
    sha256 = "sha256-PfOEGqPMGLixoqHENZnxOv9nK+dYMqe6P0k+ZiJMik0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonPath = with python3.pkgs; [
    dnspython
    m2crypto
    python-gnupg
    pyunbound
  ];

  buildInputs = [
    python3.pkgs.wrapPython
  ];

  propagatedBuildInputs = [
    unbound
    libreswan
  ] ++ pythonPath;

  propagatedUserEnvPkgs = [
    unbound
    libreswan
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "$(DESTDIR)/usr" "$out"
    substituteInPlace ipseckey \
      --replace "/usr/sbin/ipsec" "${libreswan}/sbin/ipsec"
    substituteInPlace tlsa \
      --replace "/var/lib/unbound/root" "${python3.pkgs.pyunbound}/etc/pyunbound/root"
    patchShebangs *
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man $out/lib/${python3.libPrefix}/site-packages
    make install
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Various tools to generate special DNS records";
    homepage = "https://github.com/letoams/hash-slinger";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
  };
}
