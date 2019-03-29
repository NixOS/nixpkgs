{ stdenv, opl3bankeditor, fetchFromGitHub, fetchpatch }:

opl3bankeditor.overrideAttrs (oldAttrs: rec {
  version = "1.3-beta";
  pname = "OPN2BankEditor";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = version;
    sha256 = "0blcvqfj1yj6cmm079aw4jdzv3066jxqy9krp268i6cl2b3bmwvw";
    fetchSubmodules = true;
  };

  # to be removed with next release
  postInstall = ''
    install -Dm755 opn2_bank_editor $out/bin/opn2_bank_editor
  '';
})
