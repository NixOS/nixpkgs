{ fetchurl, libiconv }:

finalAttrs: {
  version = "0.996";

  src = fetchurl {
    url = "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE";
    name = "mecab-${finalAttrs.version}.tar.gz";
    hash = "sha256-4HMyV4MTW3LmZhRceBu0j62lg9UiT7JJD7bBQDumnFk=";
  };

  buildInputs = [ libiconv ];

  configureFlags = [
    "--with-charset=utf8"
  ];

  # mecab uses several features that have been removed in C++17.
  # Force the language mode to C++14, so that it can compile with clang 16.
  makeFlags = [ "CXXFLAGS=-std=c++14" ];

  doCheck = true;
}
