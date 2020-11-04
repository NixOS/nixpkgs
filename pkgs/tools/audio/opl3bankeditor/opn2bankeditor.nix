{ opl3bankeditor, fetchFromGitHub }:

opl3bankeditor.overrideAttrs (oldAttrs: rec {
  version = "1.3";
  pname = "OPN2BankEditor";

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xsvv0gxqh1lx22f1jm384f7mq1jp57fmpsx1jjaxz435w5hf8s0";
    fetchSubmodules = true;
  };
})
