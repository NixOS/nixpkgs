{ lib, fetchzip }:
lib.mapAttrs
  (model: config: fetchzip rec {
    name = "vosk-model-${model}-${config.version}";
    url = "https://alphacephei.com/vosk/models/${name}.zip";
    inherit (config) sha256;
    meta = {
      inherit (config) license;
    };
  })
{
  # Regular models
  ar-mgb2 = {
    version = "0.4";
    sha256 = "sha256-o4DuSLWf0sBj1qUf0wT1AUzT4nqFp4UdVn5a6pgIB0A=";
    license = lib.licenses.asl20;
  };
  small-ca = {
    version = "0.4";
    sha256 = "sha256-3pN+xE09nUHUSsCIK6iNsvjlNYvsz8XeWxHowmawJgU=";
    license = lib.licenses.asl20;
  };
  cn = {
    version = "0.22";
    sha256 = "sha256-dmc9MpjAQgCC/IyiBm/sAYwgzzsbGcJPJ0ZoJAbj740=";
    license = lib.licenses.asl20;
  };
  small-cs = {
    version = "0.4-rhasspy";
    sha256 = "sha256-z58e1gKT4vb0yhkhNVznY9iIn42p7i3rldZd8QVAd7A=";
    license = lib.licenses.mit;
  };
  de = {
    version = "0.21";
    sha256 = "sha256-Pqf6Eo15aIfI3NYN1kYakUVyA6JD0hR2rW+R/2hDug4=";
    license = lib.licenses.asl20;
  };
  el-gr = {
    version = "0.7";
    sha256 = "sha256-XKavK46sX6r4GiXiYbs/+XbN+H8fAu/TC7tQE8d8NRQ=";
    license = lib.licenses.asl20;
  };
  en-in = {
    version = "0.5";
    sha256 = "sha256-sE7NkBHP7sHRyyqPIkLxNuf2aZqNeNZVpSrBVYafWSU=";
    license = lib.licenses.asl20;
  };
  en-us = {
    version = "0.22";
    sha256 = "sha256-kakOhA7hEtDM6WY3oAnb8xKZil9WTA3xePpLIxr2+yM=";
    license = lib.licenses.asl20;
  };
  small-eo = {
    version = "0.42";
    sha256 = "sha256-ZRbggC2TM9ynUPqzof/aPTVN3vlbcuZ2+trqBVsXKdQ=";
    license = lib.licenses.asl20;
  };
  small-es = {
    version = "0.22";
    sha256 = "sha256-JRe3KTikkIq7kBV+YmxW6uc0dMRRclZAhhHOI3g9HBQ=";
    license = lib.licenses.asl20;
  };
  fa = {
    version = "0.5";
    sha256 = "sha256-yUTpPFtFdfZxm+Xh8KvyyCvjtl256nc8H2zQ0WCIFrc=";
    license = lib.licenses.asl20;
  };
  fr = {
    version = "0.22";
    sha256 = "sha256-PQYByIbw1pwGJnGODkpvlzy/7cLCQK3v+zAswj53jvA=";
    license = lib.licenses.asl20;
  };
  hi = {
    version = "0.22";
    sha256 = "sha256-KSH85TYuGBHAR4fU4KDXr44YHdP7lZV11iJ+fEiti6M=";
    license = lib.licenses.asl20;
  };
  it = {
    version = "0.22";
    sha256 = "sha256-W8rg16lLQeAz6St8n3/kPdO7pbXQ1QSombF1Aq7tgIM=";
    license = lib.licenses.asl20;
  };
  ja = {
    version = "0.22";
    sha256 = "sha256-CjifemsTm6T2MnPgUOLhd7EsTqAc18N6MfhrhwBk06s=";
    license = lib.licenses.asl20;
  };
  kz = {
    version = "0.15";
    sha256 = "sha256-AcDUGa/o9709nC12Cv6+aKBDo4b9RU8oFJEwgoEyuzY=";
    license = lib.licenses.asl20;
  };
  small-nl = {
    version = "0.22";
    sha256 = "sha256-K71Zi75J7r3V6Q/uipWFywMbWIRElCbk5Nu8QN6zilE=";
    license = lib.licenses.asl20;
  };
  nl-spraakherkenning ={
    version = "0.6";
    sha256 = "sha256-BtyErVwrcUCbsGZmClWqYRytIfal05AjITzOcAIKLok=";
    license = lib.licenses.cc-by-nc-sa-40;
  };
  small-pl = {
    version = "0.22";
    sha256 = "sha256-ZiZZtbv5kbwqcIDEzaYwtJbRgmIA9Hjx86tBUk+CpPI=";
    license = lib.licenses.asl20;
  };
  small-pt = {
    version = "0.3";
    sha256 = "sha256-HG7tAQPkfMGGaGaCACIWapGHGsDAPBll5dtl7xi/AJc=";
    license = lib.licenses.asl20;
  };
  pt-fb = {
    version = "v0.1.1-20220516_2113";
    sha256 = "sha256-35z/Df34SXl/a8LwfG4/sHiDXASCRuHcks3mJ0Zn8Yo=";
    license = lib.licenses.gpl3Only;
  };
  ru = {
    version = "0.22";
    sha256 = "sha256-vxe1YJpA5hI5L3ZhpGE3vFh1kTbRkcOrletaGWLnL5M=";
    license = lib.licenses.asl20;
  };
  small-sv-rhasspy = {
    version = "0.15";
    sha256 = "sha256-JVAGCkCOHbcDsfJDJqHaWEq3If9pI1gehWhLcLmdHN4=";
    license = lib.licenses.mit;
  };
  tl-ph-generic = {
    version = "0.6";
    sha256 = "sha256-c5k/dB+Kq9iAmz6UKY/cTqIwWK6uQ6qEjz7qAvvD4oo=";
    license = lib.licenses.cc-by-nc-sa-40;
  };
  small-tr = {
    version = "0.3";
    sha256 = "sha256-IOpQTgUbH5sFP9BQg9TbzJpeRrWPNy3UAQkSloVsKig=";
    license = lib.licenses.asl20;
  };
  uk = {
    version = "v3";
    sha256 = "sha256-uxocuXspb0ec7X6Ig3yUkJ4tDX2ytn10WKS78BYeoUE=";
    license = lib.licenses.asl20;
  };
  small-vn = {
    version = "0.3";
    sha256 = "sha256-6pX1B+BhhFDQ/hPtuIdKnujSWc0BNXJnEgohe7hpaUE=";
    license = lib.licenses.asl20;
  };

  # Speaker identification models
  spk = {
    version = "0.4";
    sha256 = "sha256-wpTfZnEL1sCfpLhp+l62d8GcOinR15XnSHaLVASH4RA=";
    license = lib.licenses.asl20;
  };
}
