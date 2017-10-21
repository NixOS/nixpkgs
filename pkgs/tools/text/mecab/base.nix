{ fetchurl }:

rec {
    version = "0.996";

    src = fetchurl {
      url = https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE;
      name = "mecab-0.996.tar.gz";
      sha256 = "0ncwlqxl1hdn1x4v4kr2sn1sbbcgnhdphp0lcvk74nqkhdbk4wz0";
    };

    buildPhase = ''
      make
      make check
    '';
}
