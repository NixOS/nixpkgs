{ callPackage
, nginxMainline
, fetchpatch
, ...
} @ args:

callPackage ./generic.nix args {
  pname = "nginxQuic";

  inherit (nginxMainline) src version;

  configureFlags = [
    "--with-http_v3_module"
  ];

  extraPatches = [
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_1.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/04bc350b2919";
      hash = "sha256-zIt5epu1vox8z9oONuHF+eYLrECxVZPMOjI2rp6yBTQ=";
    })
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_2.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/08f8e9c33a08";
      hash = "sha256-w324E98LgRDaMF9RKQdUCmntMv2vxdBTPDLk+Y2Gb9Y=";
    })
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_3.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/ed593e26c79a";
      hash = "sha256-yrBKfsGlI93ln1jlvBCY5PspPED40mOH80xWH7WjXOE=";
    })
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_4.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/e4e9d7003b31";
      hash = "sha256-FVEWP4bUaWAx5aKoAvn2qFWZ6aWb9PhAJeUV25wXMrw=";
    })
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_5.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/b32b516f36b1";
      hash = "sha256-rZj0f7YXlO2hLJ/NSANHmxoawlfyFJ9z3vfu35kt7XQ=";
    })
    (fetchpatch {
      name = "CVE-2024-32760_CVE-2024-31079_CVE-2024-35200_CVE-2024-34161_6.patch";
      url = "https://hg.nginx.org/nginx/raw-rev/5b3f409d55f0";
      hash = "sha256-bURuSZyajMst2k/qIvE9XUVhEhOZ7vwlmL2zpCWyc48=";
    })
  ];
}
