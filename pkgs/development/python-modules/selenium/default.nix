{ lib
, stdenv
, fetchPypi
, fetchFromGitHub
, buildPythonPackage
, geckodriver
, urllib3
, xorg
, nixosTests
}:


let
  # Recompiling x_ignore_nofocus.so as the original one dlopen's libX11.so.6 by some
  # absolute paths. Replaced by relative path so it is found when used in nix.
  x_ignore_nofocus =
    fetchFromGitHub {
      owner = "SeleniumHQ";
      repo = "selenium";
      rev = "selenium-3.6.0";
      sha256 = "13wf4hx4i7nhl4s8xkziwxl0km1j873syrj4amragj6mpip2wn8v";
    };
in

buildPythonPackage rec {
  pname = "selenium";
  version = "3.141.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "039hf9knvl4s3hp21bzwsp1g5ri9gxsh504dp48lc6nr1av35byy";
  };

  buildInputs = [xorg.libX11];

  propagatedBuildInputs = [
    geckodriver urllib3
  ];

  patchPhase = lib.optionalString stdenv.isLinux ''
    cp "${x_ignore_nofocus}/cpp/linux-specific/"* .
    substituteInPlace x_ignore_nofocus.c --replace "/usr/lib/libX11.so.6" "${xorg.libX11.out}/lib/libX11.so.6"
    cc -c -fPIC x_ignore_nofocus.c -o x_ignore_nofocus.o
    cc -shared \
      -Wl,${if stdenv.isDarwin then "-install_name" else "-soname"},x_ignore_nofocus.so \
      -o x_ignore_nofocus.so \
      x_ignore_nofocus.o
    cp -v x_ignore_nofocus.so selenium/webdriver/firefox/${if stdenv.is64bit then "amd64" else "x86"}/
  '';

  passthru.tests = {
    testing-bitwarden = nixosTests.bitwarden;
  };

  meta = with lib; {
    description = "The selenium package is used to automate web browser interaction from Python";
    homepage = "http://www.seleniumhq.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
