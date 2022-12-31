{ fetchFromGitHub }: {
  h2o = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
    rev = "v2.2.6";
    sha256 = "0qni676wqvxx0sl0pw9j0ph7zf2krrzqc1zwj73mgpdnsr8rsib7";
  };
  libaes_siv = fetchFromGitHub {
    owner = "dfoxfranke";
    repo = "libaes_siv";
    rev = "9681279cfaa6e6399bb7ca3afbbc27fc2e19df4b";
    sha256 = "1g4wy0m5wpqx7z6nillppkh5zki9fkx9rdw149qcxh7mc5vlszzi";
  };
  murmur3 = fetchFromGitHub {
    owner = "urbit";
    repo = "murmur3";
    rev = "71a75d57ca4e7ca0f7fc2fd84abd93595b0624ca";
    sha256 = "0k7jq2nb4ad9ajkr6wc4w2yy2f2hkwm3nkbj2pklqgwsg6flxzwg";
  };
  softfloat3 = fetchFromGitHub {
    owner = "urbit";
    repo = "berkeley-softfloat-3";
    rev = "ec4c7e31b32e07aad80e52f65ff46ac6d6aad986";
    sha256 = "1lz4bazbf7lns1xh8aam19c814a4n4czq5xsq5rmi9sgqw910339";
  };

}
