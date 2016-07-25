{ fetchgit }:
[
  {
    goPackagePath = "github.com/vincent-petithory/structfield";
    src = fetchgit {
      url = "https://github.com/vincent-petithory/structfield";
      rev = "01a738558a47fbf16712994d1737fb31c77e7d11";
      sha256 = "1kyx71z13mf6hc8ly0j0b9zblgvj5lzzvgnc3fqh61wgxrsw24dw";
    };
  }
]
