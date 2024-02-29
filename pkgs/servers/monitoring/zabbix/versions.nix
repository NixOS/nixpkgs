generic: {
  v60 = generic rec {
    version = "6.0.26";
    hash = "sha256-MIOKe5hqfDecB1oWZKzbFmJCsQLuAGtp21l2WxxVG+g=";
    vendorHash = null;
    url = "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-${version}.tar.gz";
  };

  v50 = generic rec {
    version = "5.0.41";
    hash = "sha256-pPvw0lPoK1IpsXc5c8Qu9zFhx2oHJz2bwiX80vrYa58=";
    vendorHash = "sha256-qLDoNnEFiSrWXbLtYlmQaqY8Rv6JaG8WbMYBlry5Evc=";
    url = "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-${version}.tar.gz";
  };

  v40 = generic rec {
    version = "4.0.48";
    hash = "sha256-WK8Zzkd/s9M7N5Qr2kejtp/f/n1wb5zRSfh0RiI2K+Q=";
    url = "https://cdn.zabbix.com/zabbix/sources/oldstable/4.0/zabbix-${version}.tar.gz";
  };
}
