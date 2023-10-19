{ fetchurl }:

finalAttrs: {
  version = "0.996";

  src = fetchurl {
    url = "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE";
    name = "mecab-${finalAttrs.version}.tar.gz";
    hash = "sha256-4HMyV4MTW3LmZhRceBu0j62lg9UiT7JJD7bBQDumnFk=";
  };

  configureFlags = [
    "--with-charset=utf8"
  ];

  doCheck = true;
}
