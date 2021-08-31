{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "vrmiguel";
    repo = pname;
    rev = version;
    sha256 = "00ah8hgrppa61jhwb74zl5b509q0yp2pp27w9frm814iqx70qn38";
  };

  cargoPatches = [
    # a patch file to add Cargo.lock in the source code
    # https://github.com/vrmiguel/ouch/pull/46
    ./add-Cargo.lock.patch
  ];

  cargoSha256 = "181aq8r78g4bl1ndlwl54ws5ccrwph0mmk9506djxvfdy3hndxkg";

  meta = with lib; {
    description = "Taking the pain away from file (de)compression";
    homepage = "https://github.com/vrmiguel/ouch";
    license = licenses.mit;
    maintainers = [ maintainers.psibi ];
  };
}
