{ callPackage, ... }@args:

callPackage ./. (
  args
  // {
    version = "3.3.5";
    hash = "sha256-RLHx8PyfbfIDr6X6ky5/w0XsGMFd+v5PgmQHvYOaf+k=";
  }
)
