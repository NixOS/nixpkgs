{
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-698fDFHxgt84Ui9wuncCFJQL75mM224A82SSspaZdh8=";
      type = "gem";
    };
    version = "1.22.1";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2Y89y0pq4peAoiGTQMsOVduvu360zMK5n4kvJWmnph4=";
      type = "gem";
    };
    version = "1.4.6";
  };
  pgsync = {
    dependencies = [
      "parallel"
      "pg"
      "slop"
      "tty-spinner"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q+5pRADvtZwlVi0jwqq/gijEE2SBI4fCnRohepT+VLg=";
      type = "gem";
    };
    version = "0.7.4";
  };
  slop = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hEMitf/PF+1IFf2xc7BKIN2CtP2T43RMiMj6/qaW2cc=";
      type = "gem";
    };
    version = "4.10.1";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DgNvBHtP+2HyqkX1p3DsALTQQTBTFVipS/xbGStXBUI=";
      type = "gem";
    };
    version = "0.9.3";
  };
}
