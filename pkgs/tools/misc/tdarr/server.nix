{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-TW1Omn91Cu7w4jEoucXcO0q5zNWk+vQMZxbFo1JCYW8=";
    linux_arm64 = "sha256-rjdJKhSCnasZXbS5IxYZgUpRiOMywAk5VLboZfqJjzE=";
    darwin_x64 = "sha256-vuT6j5D5+cb72+NTEvBrUE3OaMT+UvpaglLsn3hjweY=";
    darwin_arm64 = "sha256-oh24QzzJheRId3nkm4r3OXxibz0IUTeg7Q5g+LfeUPE=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
