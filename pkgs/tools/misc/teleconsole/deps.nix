[
    # Teleport v2.0.0-alpha.4 required for build.
    # See https://github.com/gravitational/teleconsole/blob/09591f227c2a8df4c68af8bc4adfadfc596f4ed2/Makefile#L8
    {
      goPackagePath = "github.com/gravitational/teleport";
      fetch = {
        type = "git";
        url = "https://github.com/gravitational/teleport";
        rev = "2cb40abd8ea8fb2915304ea4888b5b9f3e5bc223";
        sha256 = "1xw3bfnjbj88x465snwwzn4bmpmzmsrq9r0pkj388qwvfrclgnfk";
      };
    }
]
