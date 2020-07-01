{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.8";
  sha256 = "0yrzhsxmjiwkhchagx8dymzhvxl3k5h40wn9wpicqjvgjb9k8523";
})
