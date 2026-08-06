{ callPackage }:

let
  mkOcis = args: callPackage ./generic.nix args;
in
{
  ocis_5-bin = mkOcis {
    pname = "ocis_5-bin";
    version = "5.0.9";
    hashes = {
      hash_386-linux = "sha256-2RtkxtVk7YN7CfsIBpMP85g84MNTzrnEgk10eFdfyyw=";
      hash_amd64-linux = "sha256-tmUfDKLO35qCs1hauJQKhJhcnMhqOpcqDFtAggMFhLE=";
      hash_arm64-linux = "sha256-ggRDW1cnTHMQKvOvCDH3eptH3O3PgYaondlzOGHTjio=";
      hash_arm-linux = "sha256-uMLRow1NeHufSI5B4k5qSIfH3lTxg+WxzLxgdedAz40=";
      hash_arm64-darwin = "sha256-k5X2ZInFS/HlToOZPX23TRJqlx/XM1ZG++Xr4BHn8SY=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_5-bin"
    ];
  };

  ocis_70-bin = mkOcis {
    pname = "ocis_70-bin";
    version = "7.0.1";
    hashes = {
      hash_386-linux = "sha256-eR5yPDwjbjCsm6/ynI/xCCyzlQUMXSlc7xPebNWQxZ8=";
      hash_amd64-linux = "sha256-MOLyuhslnKJlCbCgm+bAg/K1pFk8Q8miREOuap3egBQ=";
      hash_arm64-linux = "sha256-P1oZI7oGyQ8JmeXdBbG5WHqdXbR9zwPvHmmkiV0ajH8=";
      hash_arm-linux = "sha256-RhXkCzT8fb5/au+nJLsHRYSgLpXwFzhx2vayR/P4cfg=";
      hash_arm64-darwin = "sha256-s+Lv2OBrlRCTu4K89rJeirudzXrGBdjqKA2WBTwioUE=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_70-bin"
    ];
  };

  ocis_71-bin = mkOcis {
    pname = "ocis_71-bin";
    version = "7.1.4";
    hashes = {
      hash_386-linux = "sha256-fO/bdIj6Ez98ICjDN2r98ADsc+QxOKwcry5XfArNA54=";
      hash_amd64-linux = "sha256-l+x+pd95nDznGu7i7PQr6v56bA4ajO2Q+SE/8XYBMPc=";
      hash_arm64-linux = "sha256-jSbFMSAGwGcjuGPrbzHyh84Ww8LHStXw2oL3Y66j1H4=";
      hash_arm-linux = "sha256-gyhquYsyuEIASjF51so6tE7iauP/Gk21jpZ2+iHICAQ=";
      hash_arm64-darwin = "sha256-ryQvmTDq5M/MOXNj+ePS1lMwiTSpT/Z1oGhkuYst6dE=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_71-bin"
    ];
  };

  ocis_72-bin = mkOcis {
    pname = "ocis_72-bin";
    version = "7.2.0";
    hashes = {
      hash_386-linux = "sha256-YXEW4BOSoMdyZieXmCoH9oIR/9zBDmrkxthrX4ewfJc=";
      hash_amd64-linux = "sha256-SPnT8OrEcYl/MlUhl7hnDl1SZHF+WV/+D33bfnFbSoY=";
      hash_arm64-linux = "sha256-I8odwJEjqi4Jr8vyNDifjOwg6CznC898BpWYflgQj+M=";
      hash_arm-linux = "sha256-qoyA0lSN8BBU0X5MajJquIWvnHmMY0fZy3T/RyHQyTA=";
      hash_arm64-darwin = "sha256-KPvgvLjDtDSRHv233VUuK3oMh+8pJJovVWAoMzRqZZc=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_72-bin"
    ];
  };

  ocis_73-bin = mkOcis {
    pname = "ocis_73-bin";
    version = "7.3.2";
    hashes = {
      hash_386-linux = "sha256-2kjQyn0SgEYlD1VtoGXmWFNgja7gHnRWbcXmXbkDRn0=";
      hash_amd64-linux = "sha256-gS5EGYJoPZQjkHf48h4+nc5xQV09kERr161ZbEnCI7k=";
      hash_arm64-linux = "sha256-+ilnW14TG/33UwWZTNAtVrczHmMJRwoMXf7DuOi1sII=";
      hash_arm-linux = "sha256-QBDn3jO0P0TmqHIEu2aRXM0Q5g1EHg+2meWsrMpj0nM=";
      hash_arm64-darwin = "sha256-LSdazT9hn9cLJ9b0w3/Yk848Z0uqtSv+Pq5FQL8fhsg=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_73-bin"
    ];
  };

  ocis_80-bin = mkOcis {
    pname = "ocis_80-bin";
    version = "8.0.6";
    hashes = {
      hash_386-linux = "sha256-UgP16ltUQRYRfeR7TuHR8YDdajc7eMPmjkc53hTuKUc=";
      hash_amd64-linux = "sha256-DU+cs+uh1aYpx7QVFS60BIvOlv5cWE9phOjsbSoB1zo=";
      hash_arm64-linux = "sha256-PaTHzONx9ZFQJIt8G+Lqy1nSUmUpYsJSaXXqcsspu10=";
      hash_arm-linux = "sha256-i81Wg+YUnpThbrMAp7CgVXFadcekdVT13Q/CinRdfzY=";
      hash_arm64-darwin = "sha256-mIxrkAjSn9K/DIMqLw9pJFjd7VKRm8qQW5mmEJd8R/w=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_80-bin"
    ];
  };

  ocis_81-bin = mkOcis {
    pname = "ocis_81-bin";
    version = "8.1.0";
    hashes = {
      hash_386-linux = "sha256-sPv7H3zMNj2rcP7hOnkakssdPshyVu91mxjhbja1oQ0=";
      hash_amd64-linux = "sha256-jhGTMZkegKZYQAiEwX5LX9irUuBzrhMzhlAKXVUD6yU=";
      hash_arm64-linux = "sha256-7wlOBm/xKCphRXFbVhlsQpNl03/oPHqZ6qkbz6VCA6U=";
      hash_arm-linux = "sha256-dhvr7mjgMbMqVpAhqAxUhNtGBYv+7JfJIA3F6r1URUs=";
      hash_arm64-darwin = "sha256-Nj+OjLwtn1cWwC/pAXMp/IpzvFiT6ASAZr7NMb39S8U=";
    };
    updateScript = [
      ./update-bin.py
      "ocis_81-bin"
    ];
  };
}
