{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "legdur";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IKwEL5TKDDMX5AunRZI04MNAuv/w1pD39in8+j41P4Q=";
  };

  cargoHash = "sha256-JLiAwgghgaoINEo10My2Tc6vG9iaNL1mOe4fG/udcGw=";

  meta = with lib; {
    description = "keep your legacy durable, detect changes to your directories over time";
    longDescription = ''
      A simple CLI program to compute hashes of large
      sets of files in large directory structures and
      compare them with a previous snapshot
    '';
    homepage = "https://hg.sr.ht/~cyplo/legdur";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
