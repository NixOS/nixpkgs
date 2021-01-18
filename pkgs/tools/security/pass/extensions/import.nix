{ lib, stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper, fetchpatch }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [
    p.defusedxml
    p.setuptools
    p.pyaml
    p.pykeepass
    p.filemagic
    p.cryptography
    p.secretstorage
  ]);

in stdenv.mkDerivation rec {
  pname = "pass-import";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-import";
    rev = "v${version}";
    sha256 = "sha256-nH2xAqWfMT+Brv3z9Aw6nbvYqArEZjpM28rKsRPihqA=";
  };

  patches = [ ./0001-Fix-installation-with-Nix.patch ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ pythonEnv ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/pimport \
      --prefix PATH : "${pythonEnv}/bin" \
      --prefix PYTHONPATH : "$out/${pythonPackages.python.sitePackages}"
    wrapProgram $out/lib/password-store/extensions/import.bash \
      --prefix PATH : "${pythonEnv}/bin" \
      --prefix PYTHONPATH : "$out/${pythonPackages.python.sitePackages}"
  '';

  meta = with lib; {
    description = "Pass extension for importing data from existing password managers";
    homepage = "https://github.com/roddhjav/pass-import";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
