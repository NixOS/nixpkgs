{
  version = "15.20";
  rev = "6a84c5137e820f46f0123276f546eec5b9a56e70";
  hash = "sha256-1Ovoo3TVGWYGc97gatchDXZLjtJ8vx096d8sev7fgFo=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
